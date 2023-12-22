defmodule FoodFromHome.Deliveries.Services.InitiateDelivery do
  @moduledoc """
  Creates a new delivery with seller position as current position
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users

  def call(
        order = %Order{status: :reserved_for_pickup},
        _deliverer_user = %User{
          id: deliverer_user_id,
          user_type: :deliverer
        }
      ) do
    %User{geoposition: seller_geoposition} = Users.get_seller_user_from_order!(order)

    Deliveries.create(order, %{
      deliverer_user_id: deliverer_user_id,
      current_geoposition: seller_geoposition
    })
  end
end
