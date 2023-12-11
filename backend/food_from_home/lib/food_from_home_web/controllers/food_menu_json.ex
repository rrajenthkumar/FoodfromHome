defmodule FoodFromHomeWeb.FoodMenuJSON do
  alias FoodFromHome.FoodMenus.FoodMenu

  @doc """
  Renders a list of food menus with limited details.
  """
  def index(%{food_menus: food_menus}) do
    %{data: for(food_menu <- food_menus, do: limited_data(food_menu))}
  end

  @doc """
  Renders a single food menu with more details.
  """
  def show(%{food_menu: food_menu}) do
    %{data: data(food_menu)}
  end

  defp limited_data(food_menu = %FoodMenu{}) do
    %{
      id: food_menu.id,
      menu_illustration: food_menu.menu_illustration,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate
    }
  end

  defp data(food_menu = %FoodMenu{}) do
    %{
      id: food_menu.id,
      seller_id: food_menu.seller_id,
      allergens: food_menu.allergens,
      description: food_menu.description,
      ingredients: food_menu.ingredients,
      menu_illustration: food_menu.menu_illustration,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate,
      preparation_time_in_minutes: food_menu.preparation_time_in_minutes
    }
  end
end
