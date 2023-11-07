defmodule FoodFromHomeWeb.FoodMenuJSON do
  alias FoodFromHome.FoodMenus.FoodMenu

  @doc """
  Renders a list of food_menus.
  """
  def index(%{food_menus: food_menus}) do
    %{data: for(food_menu <- food_menus, do: data(food_menu))}
  end

  @doc """
  Renders a single food_menu.
  """
  def show(%{food_menu: food_menu}) do
    %{data: data(food_menu)}
  end

  defp data(%FoodMenu{} = food_menu) do
    %{
      id: food_menu.id,
      allergens: food_menu.allergens,
      description: food_menu.description,
      ingredients: food_menu.ingredients,
      menu_illustration: food_menu.menu_illustration,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate
    }
  end
end
