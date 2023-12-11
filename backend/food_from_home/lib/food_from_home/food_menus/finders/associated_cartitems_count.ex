defmodule FoodFromHome.FoodMenus.Finders.AssociatedCartitems do
  @moduledoc """
  To check if an associated cart item exists
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo

  def check?(%FoodMenu{id: food_menu_id}) do
    query =
      from cart_item in CartItem,
        where: cart_item.food_menu_id == ^food_menu_id

    Repo.aggregate(query, :count, :id) > 0
  end
end
