defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  defdelegate create(attrs, seller_id), to: FoodMenuRepo
  defdelegate get!(menu_id), to: FoodMenuRepo
  defdelegate update(attrs, menu_id), to: FoodMenuRepo
  defdelegate delete(menu_id), to: FoodMenuRepo
  defdelegate list(params_with_filters), to: FoodMenuRepo
end
