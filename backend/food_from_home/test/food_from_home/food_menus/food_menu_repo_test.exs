defmodule FoodFromHome.FoodMenus.FoodMenuRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.FoodMenus.FoodMenuRepo

  describe "food_menus" do
    alias FoodFromHome.FoodMenus.FoodMenu

    import FoodFromHome.FoodMenusFixtures

    @invalid_attrs %{description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}

    test "list_food_menus/0 returns all food_menus" do
      food_menu = food_menu_fixture()
      assert FoodMenuRepo.list_food_menus() == [food_menu]
    end

    test "get_food_menu!/1 returns the food_menu with given id" do
      food_menu = food_menu_fixture()
      assert FoodMenuRepo.get_food_menu!(food_menu.id) == food_menu
    end

    test "create_food_menu/1 with valid data creates a food_menu" do
      valid_attrs = %{description: "some description", ingredients: ["egg", "milk"], menu_illustration: "some menu_illustration", name: "some name", preparation_time_in_minutes: 42, price: "120.5", valid_until: ~U[2023-10-30 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.create_food_menu(valid_attrs)
      assert food_menu.allergens == []
      assert food_menu.description == "some description"
      assert food_menu.ingredients == ["egg", "milk"]
      assert food_menu.menu_illustration == "some menu_illustration"
      assert food_menu.name == "some name"
      assert food_menu.preparation_time_in_minutes == 42
      assert food_menu.price == Decimal.new("120.5")
      assert food_menu.rebate == nil
      assert food_menu.valid_until == ~U[2023-10-30 14:28:00Z]
    end

    test "create_food_menu/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FoodMenuRepo.create_food_menu(@invalid_attrs)
    end

    test "update_food_menu/2 with valid data updates the food_menu" do
      food_menu = food_menu_fixture()
      update_attrs = %{allergens: ["gluten"], description: "some updated description", ingredients: ["sugar", "wheat flour"], menu_illustration: "some updated menu_illustration", name: "some updated name", preparation_time_in_minutes: 43, price: "456.7", rebate: %{}, valid_until: ~U[2023-10-31 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.update_food_menu(food_menu.id, update_attrs)
      assert food_menu.allergens == ["gluten"]
      assert food_menu.description == "some updated description"
      assert food_menu.ingredients == ["sugar", "wheat flour"]
      assert food_menu.menu_illustration == "some updated menu_illustration"
      assert food_menu.name == "some updated name"
      assert food_menu.preparation_time_in_minutes == 43
      assert food_menu.price == Decimal.new("456.7")
      assert food_menu.rebate == %{}
      assert food_menu.valid_until == ~U[2023-10-31 14:28:00Z]
    end

    test "update_food_menu/2 with invalid data returns error changeset" do
      food_menu = food_menu_fixture()
      assert {:error, %Ecto.Changeset{}} = FoodMenuRepo.update_food_menu(food_menu.id, @invalid_attrs)
      assert food_menu == FoodMenuRepo.get_food_menu!(food_menu.id)
    end

    test "delete_food_menu/1 deletes the food_menu" do
      food_menu = food_menu_fixture()
      assert {:ok, %FoodMenu{}} = FoodMenuRepo.delete_food_menu(food_menu.id)
      assert_raise Ecto.NoResultsError, fn -> FoodMenuRepo.get_food_menu!(food_menu.id) end
    end

    test "change_food_menu/1 returns a food_menu changeset" do
      food_menu = food_menu_fixture()
      assert %Ecto.Changeset{} = FoodMenuRepo.change_food_menu(food_menu)
    end
  end
end
