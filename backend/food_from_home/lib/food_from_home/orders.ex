defmodule FoodFromHome.Orders do
  @moduledoc """
  The Orders context.
  """
  alias FoodFromHome.Orders.Finders.OrderWithAssociatedData
  alias FoodFromHome.Orders.OrderRepo

  alias FoodFromHome.Orders.Services.SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent

  alias FoodFromHome.Orders.Services.SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent

  alias FoodFromHome.Orders.Services.SetDeliveredStatusAndAddDeliveryTimeToDeliveryAndProduceDeliveryCompletedEvent

  alias FoodFromHome.Orders.Services.SetOnTheWayStatusAndAddPickupTimeToDeliveryAndProduceDeliveryStartedEvent

  alias FoodFromHome.Orders.Services.SetReadyForPickupStatus
  alias FoodFromHome.Orders.Services.SetReservedForPickupStatusAndInitiateDelivery
  alias FoodFromHome.Orders.Services.UpdateDeliveryAddress
  alias FoodFromHome.Orders.Utils

  defdelegate create_order(buyer_user, attrs), to: OrderRepo
  defdelegate list_order(user, filters), to: OrderRepo
  defdelegate get_order(order_id), to: OrderRepo
  defdelegate get_order!(order_id), to: OrderRepo
  defdelegate delete_order(order), to: OrderRepo

  def get_order_with_associated_data(order_id), do: OrderWithAssociatedData.get(order_id)

  def update_order_delivery_address(order, delivery_address),
    do: UpdateDeliveryAddress.call(order, delivery_address)

  def cancel_order(order, seller_remark),
    do:
      SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent.call(order, seller_remark)

  def confirm_order(order, invoice_link),
    do: SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent.call(order, invoice_link)

  def mark_order_as_ready_for_pickup(order), do: SetReadyForPickupStatus.call(order)

  def reserve_order_for_pickup(order, deliverer_user),
    do: SetReservedForPickupStatusAndInitiateDelivery.call(order, deliverer_user)

  def mark_order_as_on_the_way(order),
    do: SetOnTheWayStatusAndAddPickupTimeToDeliveryAndProduceDeliveryStartedEvent.call(order)

  def mark_order_as_delivered(order),
    do: SetDeliveredStatusAndAddDeliveryTimeToDeliveryAndProduceDeliveryCompletedEvent.call(order)

  defdelegate is_order_related_to_user?(order, user), to: Utils
end
