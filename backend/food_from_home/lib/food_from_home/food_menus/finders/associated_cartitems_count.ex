defmodule FoodFromHome.FoodMenus.Finders.AssociatedCartitemsCount do
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu

  def get(food_menu = %FoodMenu{id: food_menu_id}) do
    query =
      from cart_item in CartItem,
        where: cart_item.food_menu_id == ^food_menu_id

    Repo.aggregate(query, :count, :id)
  end
end
