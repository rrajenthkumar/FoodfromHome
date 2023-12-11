defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  Interface to all FoodMenu related methods for other contexts.
  """
  alias FoodFromHome.FoodMenus.Finders.AssociatedCartitems
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create_food_menu(seller, attrs), to: FoodMenuRepo
  defdelegate list_food_menu(seller, filters), to: FoodMenuRepo
  defdelegate get_food_menu(food_menu_id), to: FoodMenuRepo
  defdelegate get_food_menu!(food_menu_id), to: FoodMenuRepo
  defdelegate update_food_menu(food_menu, attrs), to: FoodMenuRepo
  defdelegate delete_food_menu(food_menu), to: FoodMenuRepo

  def has_associated_cart_items?(food_menu), do: AssociatedCartitems.check?(food_menu)
end
