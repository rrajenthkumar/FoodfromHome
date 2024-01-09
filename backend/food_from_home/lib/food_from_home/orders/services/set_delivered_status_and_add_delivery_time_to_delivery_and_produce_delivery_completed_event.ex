defmodule FoodFromHome.Orders.Services.SetDeliveredStatusAndAddDeliveryTimeToDeliveryAndProduceDeliveryCompletedEvent do
  @moduledoc """
  When a deliverer delivers an order, the status of the order is changed to :delivered.
  Simultaneously the corresponding delivery record is updated with the delivery time.
  Then a delivery_completed Kafka event is produced to be consumed by the notification module.
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.OrderRepo

  def call(order = %Order{id: order_id, status: :on_the_way}) do
    case OrderRepo.update_order(order, %{status: :delivered}) do
      {:ok, %Order{} = order} ->
        case Producer.send_message("delivery_completed", {"order_id", "#{order_id}"}) do
          :ok -> add_delivery_time_to_delivery(order)
          error -> error
        end

      error ->
        error
    end
  end

  def call(%Order{status: another_status}) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :on_the_way status can be changed to :delivered status."}
  end

  defp add_delivery_time_to_delivery(order = %Order{status: :delivered}) do
    result =
      order
      |> Deliveries.get_delivery_from_order!()
      |> Deliveries.add_delivery_time()

    case result do
      {:ok, %Delivery{}} ->
        # KafkaAgent.produce_delivery_completed_event()
        {:ok, order}

      {:error, delivery_time_addition_error_reason} ->
        # Rollingback status change
        case OrderRepo.update_order(order, %{status: :on_the_way}) do
          {:ok, %Order{}} ->
            {:error, 500,
             "The status update operation has been rolled back as delivery time addition to the associated delivery failed due to the following reason: #{delivery_time_addition_error_reason}"}

          {:error, reason} ->
            {:error, 500,
             "Delivery time addition to the associated delivery failed due to the following reason: #{delivery_time_addition_error_reason} and the eventual order status update rollback too failed due to the following reason: #{reason}"}
        end
    end
  end
end
