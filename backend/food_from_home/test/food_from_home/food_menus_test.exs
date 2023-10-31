defmodule FoodFromHome.FoodMenusTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.FoodMenus

  describe "food_menus" do
    alias FoodFromHome.FoodMenus.FoodMenu

    import FoodFromHome.FoodMenusFixtures

    @invalid_attrs %{allergens: nil, description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, rebate: nil, valid_until: nil}

    test "list_food_menus/0 returns all food_menus" do
      food_menu = food_menu_fixture()
      assert FoodMenus.list_food_menus() == [food_menu]
    end

    test "get_food_menu!/1 returns the food_menu with given id" do
      food_menu = food_menu_fixture()
      assert FoodMenus.get_food_menu!(food_menu.id) == food_menu
    end

    test "create_food_menu/1 with valid data creates a food_menu" do
      valid_attrs = %{allergens: :lactose, description: "some description", ingredients: :egg, menu_illustration: "some menu_illustration", name: "some name", preparation_time_in_minutes: 42, price: "120.5", rebate: %{}, valid_until: ~U[2023-10-30 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenus.create_food_menu(valid_attrs)
      assert food_menu.allergens == :lactose
      assert food_menu.description == "some description"
      assert food_menu.ingredients == :egg
      assert food_menu.menu_illustration == "some menu_illustration"
      assert food_menu.name == "some name"
      assert food_menu.preparation_time_in_minutes == 42
      assert food_menu.price == Decimal.new("120.5")
      assert food_menu.rebate == %{}
      assert food_menu.valid_until == ~U[2023-10-30 14:28:00Z]
    end

    test "create_food_menu/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FoodMenus.create_food_menu(@invalid_attrs)
    end

    test "update_food_menu/2 with valid data updates the food_menu" do
      food_menu = food_menu_fixture()
      update_attrs = %{allergens: :gluten, description: "some updated description", ingredients: :sugar, menu_illustration: "some updated menu_illustration", name: "some updated name", preparation_time_in_minutes: 43, price: "456.7", rebate: %{}, valid_until: ~U[2023-10-31 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenus.update_food_menu(food_menu, update_attrs)
      assert food_menu.allergens == :gluten
      assert food_menu.description == "some updated description"
      assert food_menu.ingredients == :sugar
      assert food_menu.menu_illustration == "some updated menu_illustration"
      assert food_menu.name == "some updated name"
      assert food_menu.preparation_time_in_minutes == 43
      assert food_menu.price == Decimal.new("456.7")
      assert food_menu.rebate == %{}
      assert food_menu.valid_until == ~U[2023-10-31 14:28:00Z]
    end

    test "update_food_menu/2 with invalid data returns error changeset" do
      food_menu = food_menu_fixture()
      assert {:error, %Ecto.Changeset{}} = FoodMenus.update_food_menu(food_menu, @invalid_attrs)
      assert food_menu == FoodMenus.get_food_menu!(food_menu.id)
    end

    test "delete_food_menu/1 deletes the food_menu" do
      food_menu = food_menu_fixture()
      assert {:ok, %FoodMenu{}} = FoodMenus.delete_food_menu(food_menu)
      assert_raise Ecto.NoResultsError, fn -> FoodMenus.get_food_menu!(food_menu.id) end
    end

    test "change_food_menu/1 returns a food_menu changeset" do
      food_menu = food_menu_fixture()
      assert %Ecto.Changeset{} = FoodMenus.change_food_menu(food_menu)
    end
  end
end
