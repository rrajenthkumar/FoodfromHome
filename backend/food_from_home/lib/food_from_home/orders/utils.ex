defmodule FoodFromHome.Orders.Utils do
  @moduledoc """
  Utility functions related to Order context
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  def is_order_related_to_user?(
        %Order{seller_id: order_seller_id},
        user = %User{user_type: :seller}
      ) do
    %Seller{id: user_seller_id} = Sellers.get_seller_from_user!(user)
    order_seller_id === user_seller_id
  end

  def is_order_related_to_user?(%Order{buyer_user_id: order_buyer_user_id}, %User{
        id: user_id,
        user_type: :buyer
      }) do
    order_buyer_user_id === user_id
  end

  def is_order_related_to_user?(order = %Order{}, %User{id: user_id, user_type: :deliverer}) do
    %Delivery{deliverer_user_id: order_deliverer_user_id} =
      Deliveries.get_delivery_from_order!(order)

    order_deliverer_user_id === user_id
  end
end
