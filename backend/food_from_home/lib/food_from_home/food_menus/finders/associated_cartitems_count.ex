defmodule FoodFromHome.FoodMenus.Finders.AssociatedCartitemsCount do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo

  def get(%FoodMenu{id: food_menu_id}) do
    query =
      from cart_item in CartItem,
        where: cart_item.food_menu_id == ^food_menu_id

    Repo.aggregate(query, :count, :id)
  end
end
