defmodule FoodFromHome.FoodMenusFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.FoodMenus` context.
  """

  @doc """
  Generate a food_menu.
  """
  def food_menu_fixture(attrs \\ %{}) do
    {:ok, food_menu} =
      attrs
      |> Enum.into(%{
        allergens: :lactose,
        description: "some description",
        ingredients: :egg,
        menu_illustration: "some menu_illustration",
        name: "some name",
        preparation_time_in_minutes: 42,
        price: "120.5",
        rebate: %{},
        valid_until: ~U[2023-10-30 14:28:00Z]
      })
      |> FoodFromHome.FoodMenus.create_food_menu()

    food_menu
  end
end
