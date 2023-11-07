defmodule FoodFromHome.FoodMenus.Finders.ListActiveFoodMenusFromSeller do
  @moduledoc """
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.FoodMenus.FoodMenu

  @doc """
  Returns the list of active food_menus from a seller.

  ## Examples

    iex> find(12345)
    [%FoodMenu{}, ...]

  """
  def find(seller_id) do
    query =
      from(food_menu in FoodMenu,
        join: seller in assoc(food_menu, :sellers),
        where: seller.id == ^seller_id,
        select: {food_menu.name, food_menu.description, food_menu.menu_illustration, food_menu.ingredients, food_menu.allergens, food_menu.price, food_menu.rebate},
        preload: [sellers: seller]
      )

    Repo.all(query)
  end
end
