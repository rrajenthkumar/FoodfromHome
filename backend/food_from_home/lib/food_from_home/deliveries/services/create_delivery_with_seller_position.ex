defmodule FoodFromHome.Deliveries.Services.CreateDeliveryWithSellerPosition do
  @moduledoc """
  Creates a new delivery with seller position as current position
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Geocoding
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users

  def call(order = %Order{status: :reserved_for_pickup}, %User{
        id: deliverer_user_id,
        user_type: :deliverer
      }) do
    %User{address: seller_address} = Users.find_seller_user_from_order!(order)

    case Geocoding.get_position(seller_address) do
      {:ok, %Geo.Point{} = seller_position} ->
        Deliveries.create(order, %{
          deliverer_user_id: deliverer_user_id,
          current_position: seller_position
        })

      error ->
        error
    end
  end
end
