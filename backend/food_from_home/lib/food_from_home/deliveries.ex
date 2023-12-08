defmodule FoodFromHome.Deliveries do
  @moduledoc """
  The Deliveries context.
  """
  alias FoodFromHome.Deliveries.DeliveryRepo
  alias FoodFromHome.Deliveries.Finders.DeliveryFromOrder
  alias FoodFromHome.Deliveries.Finders.DeliveriesFromUser
  alias FoodFromHome.Deliveries.Services.AddPickupTime
  alias FoodFromHome.Deliveries.Services.AddDeliveryTime
  alias FoodFromHome.Deliveries.Services.CreateDeliveryWithSellerPosition

  defdelegate create(order, attrs), to: DeliveryRepo
  defdelegate get_with_order_id!(order_id), to: DeliveryRepo
  defdelegate update(order, attrs), to: DeliveryRepo

  def find_delivery_from_order!(order), do: DeliveryFromOrder.find!(order)

  def list_deliveries_from_user(seller_or_deliverer_user, filters),
    do: DeliveriesFromUser.list(seller_or_deliverer_user, filters)

  def initiate_delivery(order, deliverer_user),
    do: CreateDeliveryWithSellerPosition.call(order, deliverer_user)

  def add_pickup_time(delivery), do: AddPickupTime.call(delivery)
  def add_delivery_time(delivery), do: AddDeliveryTime.call(delivery)
end
