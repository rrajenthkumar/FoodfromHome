defmodule FoodFromHome.Orders.Services.SetDeliveredStatusAndUpdateDeliveryAndProduceDeliveryCompletedEvent do
  @moduledoc """
  When a deliverer delivers an order, the status of the order is changed to ':delivered'.
  Simultaneously the corresponding delivery record is updated with the delivery time.
  Then a 'delivered' Kafka event is produced to be consumed by the notification module.
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order

  def call(order = %Order{status: :on_the_way}) do
    case Orders.update(order, %{status: :delivered}) do
      {:ok, %Order{} = order} ->
        case add_delivery_time(order) do
          {:ok, %Delivery{}} ->
            # produce_delivery_completed_event()
            {:ok, order}
          {:error, delivery_time_addition_error_reason} ->
            # Rollingback status change
            case Orders.update(order, %{status: :on_the_way}) do
              {:ok, %Order{}} ->
                {:error, 500, "The status update operation has been rolled back as delivery time addition to the associated delivery failed due to the following reason: #{delivery_time_addition_error_reason}. "}
              {:error, reason} ->
                {:error, 500, "Delivery time addition to the associated delivery failed due to the following reason: #{delivery_time_addition_error_reason} and the eventual order status update rollback also failed due to the following reason: #{reason}."}
            end
        end
      error ->
        error
    end
  end

  def call(%Order{status: another_status}) do
    {:error, 403, "Order in #{another_status} status. Only an order of :on_the_way status can be changed to :delivered status"}
  end

  defp add_delivery_time(order = %Order{}) do
    order
    |> Deliveries.find_delivery_from_order!()
    |> Deliveries.add_delivery_time()
  end
end
