defmodule FoodFromHome.Orders do
  @moduledoc """
  The Orders context.
  """
  alias FoodFromHome.Orders.Services.UpdateDeliveryAddress
  alias FoodFromHome.Orders.Services.SetReadyForPickupStatus
  alias FoodFromHome.Orders.Services.SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent
  alias FoodFromHome.Orders.Services.SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent
  alias FoodFromHome.Orders.Services.SetReservedForPickupStatusAndCreateDelivery
  alias FoodFromHome.Orders.Services.SetOnTheWayStatusAndUpdateDeliveryAndProduceDeliveryStartedEvent
  alias FoodFromHome.Orders.Services.SetDeliveredStatusAndUpdateDeliveryAndProduceDeliveryCompletedEvent

  defdelegate create(buyer_user_id, attrs), to: OrderRepo
  defdelegate list(user, filters), to: OrderRepo
  defdelegate get!(order_id), to: OrderRepo
  defdelegate update(order, attrs), to: OrderRepo
  # Used when last cart item is deleted in an open order
  defdelegate delete(order), to: OrderRepo

  def update_delivery_address(order, delivery_address), do: UpdateDeliveryAddress.call(order, delivery_address)
  def mark_as_ready_for_pickup(order), do: SetReadyForPickupStatus.call(order)
  # Used after payment is successful
  def confirm(order, invoice_link), do: SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent.call(order, invoice_link)
  def cancel(order, seller_remark), do: SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent.call(order, seller_remark)
  def reserve_for_pickup(order, deliverer_user), do: SetReservedForPickupStatusAndCreateDelivery.call(order, deliverer_user)
  def mark_as_on_the_way(order), do: SetOnTheWayStatusAndUpdateDeliveryAndProduceDeliveryStartedEvent.call(order)
  def mark_as_delivered(order), do: SetDeliveredStatusAndUpdateDeliveryAndProduceDeliveryCompletedEvent.call(order)
end
