defmodule FoodFromHome.Orders.Services.SetReservedForPickupStatusAndCreateDelivery do
  @moduledoc """
  When a deliverer reserves an order for pickup, the status of the order is changed to ':reserved_for_pickup'.
  Simultaneously a new delivery record is created with current location.
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.GoogleGeocoding
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def call(order = %Order{status: :confirmed}, deliverer_user = %User{id: deliverer_user_id, user_type: :deliverer}) do
    Orders.update(order, %{status: :reserved_for_pickup})

    Deliveries.create(order, %{deliverer_user_id: deliverer_user_id, current_position: get_start_position(order)})
  end

  defp get_start_position(order) do
    _seller_user = %User{address: address} = Users.find_seller_user_from_order!(order)
    GoogleGeocoding.get_position(address)
  end
end
