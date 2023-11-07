defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context which is the interface for other contexts.
  """
  alias FoodFromHome.FoodMenus.Finders
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  def list_active_food_menus_from_seller(seller_id) do
    Finders.ListActiveFoodMenusFromSeller.find(seller_id)
  end

  defdelegate create_food_menu(attrs), to: FoodMenuRepo

  defdelegate update_food_menu(menu_id, attrs), to: FoodMenuRepo

  defdelegate delete_food_menu(menu_id), to: FoodMenuRepo
end
