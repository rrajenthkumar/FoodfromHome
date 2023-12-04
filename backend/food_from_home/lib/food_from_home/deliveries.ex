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
  defdelegate get!(delivery_id), to: DeliveryRepo
  defdelegate update(order, attrs), to: DeliveryRepo

  def find_delivery_from_order!(order), do: DeliveryFromOrder.find!(order)
  def find_deliveries_from_user(user, filter_params), do: DeliveriesFromUser.find(user, filter_params)
  def initiate_delivery(order, deliverer_user), to: CreateDeliveryWithSellerPosition.call(order, deliverer_user)
  def add_pickup_time(delivery), to: AddPickupTime.call(delivery)
  def add_delivery_time(delivery), to: AddDeliveryTime.call(delivery)

end
