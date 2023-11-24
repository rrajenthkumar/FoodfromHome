defmodule FoodFromHome.Orders.Services.SetOnTheWayStatusAndUpdateDeliveryAndProduceDeliveryStartedEvent do
  @moduledoc """
  When a deliverer picks up an order that he has reserved for pickup, the status of the order is changed to ':on_the_way'.
  Simultaneously the corresponding delivery record is updated with the pickup time.
  Then a 'delivery_started' Kafka event is produced.
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order

  def call(order = %Order{status: :reserved_for_pickup}) do
    Orders.update(order, %{status: :on_the_way})

    picked_up_at = DateTime.utc_now()

    order
    |> Deliveries.find_delivery_from_order!()
    |> Deliveries.update(%{picked_up_at: picked_up_at})

    #produce_delivery_started_event()
  end
end
