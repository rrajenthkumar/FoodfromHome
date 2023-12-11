defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  Interface to all FoodMenu related methods for other contexts.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create(seller_id, attrs), to: FoodMenuRepo
  defdelegate list(seller_id, filters), to: FoodMenuRepo
  defdelegate get(food_menu_id), to: FoodMenuRepo
  defdelegate get!(food_menu_id), to: FoodMenuRepo
  defdelegate update(food_menu_id, attrs), to: FoodMenuRepo
  defdelegate delete(food_menu_id), to: FoodMenuRepo
end
