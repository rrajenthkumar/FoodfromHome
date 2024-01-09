defmodule FoodFromHome.Orders.Services.SetOnTheWayStatusAndAddPickupTimeToDeliveryAndProduceDeliveryStartedEvent do
  @moduledoc """
  When a deliverer picks up an order that he has reserved for pickup, the status of the order is changed to :on_the_way.
  Simultaneously the corresponding delivery record is updated with the pickup time.
  Then a delivery_started Kafka event is produced to be consumed by the notification module.
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.OrderRepo

  def call(order = %Order{id: order_id, status: :reserved_for_pickup}) do
    case OrderRepo.update_order(order, %{status: :on_the_way}) do
      {:ok, %Order{} = order} ->
        case Producer.send_message("delivery_started", {"order_id", "#{order_id}"}) do
          :ok -> add_pickup_time_to_delivery(order)
          error -> error
        end

      error ->
        error
    end
  end

  def call(%Order{status: another_status}) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :reserved_for_pickup status can be changed to :on_the_way status."}
  end

  defp add_pickup_time_to_delivery(order = %Order{status: :on_the_way}) do
    result =
      order
      |> Deliveries.get_delivery_from_order!()
      |> Deliveries.add_pickup_time()

    case result do
      {:ok, %Delivery{}} ->
        # KafkaAgent.produce_delivery_started_event()
        {:ok, order}

      {:error, pickup_time_addition_error_reason} ->
        # Rollingback status change
        case OrderRepo.update_order(order, %{status: :reserved_for_pickup}) do
          {:ok, %Order{}} ->
            {:error, 500,
             "The status update operation has been rolled back as pickup time addition to the associated delivery failed due to the following reason: #{pickup_time_addition_error_reason}"}

          {:error, reason} ->
            {:error, 500,
             "Pickup time addition to the associated delivery failed due to the following reason: #{pickup_time_addition_error_reason} and the eventual order status update rollback too failed due to the following reason: #{reason}"}
        end
    end
  end
end
