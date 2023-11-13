defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create_food_menu(seller_id, attrs), to: FoodMenuRepo
  defdelegate get_food_menu!(menu_id), to: FoodMenuRepo
  defdelegate update_food_menu(menu_id, attrs), to: FoodMenuRepo
  defdelegate delete_food_menu(menu_id), to: FoodMenuRepo
  defdelegate list_food_menus(filter_params), to: FoodMenuRepo
end
