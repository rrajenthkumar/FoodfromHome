defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context which is the interface for other contexts.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create_food_menu(seller_id, attrs), to: FoodMenuRepo
  defdelegate get_food_menu!(menu_id), to: FoodMenuRepo
  defdelegate list_active_food_menus_from_seller(seller_id), to: FoodMenuRepo
  defdelegate update_food_menu(menu_id, attrs), to: FoodMenuRepo
  defdelegate delete_food_menu(menu_id), to: FoodMenuRepo
end
