defmodule FoodFromHome.Orders do
  @moduledoc """
  The Orders context.
  """
  # alias FoodFromHome.Orders.Services.SetOnTheWayStatusAndUpdateDeliveryAndProduceDeliveryStartedEvent
  # alias FoodFromHome.Orders.Services.SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent
  # alias FoodFromHome.Orders.Services.SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent
  # alias FoodFromHome.Orders.Services.SetDeliveredStatusAndUpdateDeliveryAndProduceDeliveryCompletedEvent
  # alias FoodFromHome.Orders.Services.SetReservedForPickupStatusAndCreateDelivery

  defdelegate create(buyer_user_id, attrs), to: OrderRepo
  defdelegate list(user, filters), to: OrderRepo
  defdelegate get!(order_id), to: OrderRepo
  defdelegate update(order, attrs), to: OrderRepo
  defdelegate delete(order), to: OrderRepo

  # def set_confirmed_status(order_id), do: SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent.call(order_id)
  # def set_cancelled_status(order_id), do: SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent.call(order_id)
  # def set_reserved_for_pickup_status(order_id, deliverer_user_id), do: SetReservedForPickupStatusAndCreateDelivery.call(order_id, deliverer_user_id)
  # def set_on_the_way_status(order_id), do: SetOnTheWayStatusAndUpdateDeliveryAndProduceDeliveryStartedEvent.call(order_id)
  # def set_delivered_status(order_id), do: SetDeliveredStatusAndUpdateDeliveryAndProduceDeliveryCompletedEvent.call(order_id)
end
