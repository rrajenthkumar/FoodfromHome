defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create(seller_id, attrs), to: FoodMenuRepo
  defdelegate get!(menu_id), to: FoodMenuRepo
  defdelegate update(menu_id, attrs), to: FoodMenuRepo
  defdelegate delete(menu_id), to: FoodMenuRepo
  defdelegate list(seller_id, filters), to: FoodMenuRepo
end
