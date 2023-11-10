defmodule FoodFromHome.Sellers.Finders.SellerDetailsWithActiveFoodMenusTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.Sellers.SellerRepoFixtures
  alias FoodFromHome.Sellers.Finders.SellerDetailsWithActiveFoodMenus

  test "find/1 returns seller with list of active food menus in ascending order" do
    seller1 = SellerRepoFixtures.seller_fixture()

    {:ok, _food_menu_1} = %{
      description: "some description",
      ingredients: ["egg", "butter"],
      allergens: ["lactose"],
      menu_illustration: "some menu_illustration",
      name: "some name",
      preparation_time_in_minutes: 40,
      price: 12.5,
      rebate: %{},
      valid_until: ~U[2100-10-30 14:28:00Z]
    }
    |> FoodMenus.create_food_menu(seller1.id)

    seller2 = SellerRepoFixtures.seller_fixture(%{introduction: "some new introduction", illustration: "sone new illustration"})

    # Active food menus
    {:ok, food_menu_2} = %{
      description: "some new description",
      ingredients: ["whear flour", "oil"],
      allergens: ["gluten"],
      menu_illustration: "some new menu_illustration",
      name: "b",
      preparation_time_in_minutes: 50,
      price: 8,
      rebate: %{},
      valid_until: ~U[2100-10-31 14:28:00Z]
    }
    |> FoodMenus.create_food_menu(seller2.id)

    {:ok, food_menu_3} = %{
      description: "some another description",
      ingredients: ["mango", "milk", "sugar"],
      allergens: [],
      menu_illustration: "some another menu_illustration",
      name: "a",
      preparation_time_in_minutes: 50,
      price: 5,
      rebate: %{},
      valid_until: ~U[2100-10-31 14:28:00Z]
    }
    |> FoodMenus.create_food_menu(seller2.id)

    # Inactive food menu
    {:ok, _food_menu_4} =%{
      description: "some very new description",
      ingredients: ["chicken", "onion", "tomato"],
      allergens: [],
      menu_illustration: "some very new menu_illustration",
      name: "some very new name",
      preparation_time_in_minutes: 30,
      price: 10,
      rebate: %{},
      valid_until: ~U[2023-11-09 14:28:00Z]
    }
    |> FoodMenus.create_food_menu(seller2.id)

    result = SellerDetailsWithActiveFoodMenus.find(seller2.id)
    assert result.id == seller2.id
    assert result.tax_id == seller2.tax_id
    assert result.introduction == seller2.introduction
    assert result.illustration == seller2.illustration
    assert result.food_menus == [food_menu_3, food_menu_2]
  end

  test "find/1 returns Ecto.NoResultsError when the seller searched exists but does not have an active menu" do
    seller = SellerRepoFixtures.seller_fixture()

    {:ok, _food_menu} = %{
      description: "a description",
      ingredients: ["mutton", "butter"],
      allergens: ["lactose"],
      menu_illustration: "a menu_illustration",
      name: "a name",
      preparation_time_in_minutes: 60,
      price: 14.5,
      rebate: %{},
      valid_until: ~U[2023-11-09 14:28:00Z]
    }
    |> FoodMenus.create_food_menu(seller.id)

    assert_raise Ecto.NoResultsError, fn -> SellerDetailsWithActiveFoodMenus.find(seller.id) end
  end

  test "find/1 returns Ecto.NoResultsError when the seller does not exist" do
    assert_raise Ecto.NoResultsError, fn -> SellerDetailsWithActiveFoodMenus.find("12345") end
  end
end
