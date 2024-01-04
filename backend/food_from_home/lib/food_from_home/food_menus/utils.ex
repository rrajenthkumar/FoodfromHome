defmodule FoodFromHome.FoodMenus.Utils do
  @moduledoc """
  Utility functions related to Food menu context
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def food_menu_belongs_to_seller?(
        %FoodMenu{
          seller_id: food_menu_seller_id
        },
        %Seller{id: seller_id}
      ) do
    food_menu_seller_id === seller_id
  end

  def has_associated_cart_items?(%FoodMenu{id: food_menu_id}) do
    query =
      from cart_item in CartItem,
        where: cart_item.food_menu_id == ^food_menu_id

    Repo.aggregate(query, :count, :id) > 0
  end
end
