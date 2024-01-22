defmodule FoodFromHome.FoodMenus.FoodMenuRepoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.FoodMenus.FoodMenuRepo`.
  """
  alias FoodFromHome.FoodMenus.FoodMenuRepo
  alias FoodFromHome.Sellers.SellerRepoFixtures

  @doc """
  Generate a food_menu.
  """
  def food_menu_fixture(attrs \\ %{}, seller_id \\ nil) do
    seller_id =
      case seller_id do
        nil ->
          seller = SellerRepoFixtures.seller_fixture()
          seller.id

        seller_id ->
          seller_id
      end

    {:ok, food_menu} =
      attrs
      |> Enum.into(%{
        description: "some description",
        ingredients: ["egg", "butter"],
        allergens: ["lactose"],
        menu_illustration: "some menu_illustration",
        name: "some name",
        preparation_time_in_minutes: 42,
        price: 12.5,
        rebate: %{},
        valid_until: ~U[2100-10-30 14:28:00Z]
      })
      |> FoodMenuRepo.create_food_menu(seller_id)

    food_menu
  end
end
