defmodule FoodFromHome.FoodMenus.FoodMenuRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.FoodMenus.FoodMenuRepo
  alias FoodFromHome.FoodMenus.FoodMenuRepoFixtures
  alias FoodFromHome.Sellers.SellerRepoFixtures

    @invalid_attrs %{description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}

    setup do
      food_menu = FoodMenuRepoFixtures.food_menu_fixture()
      %{food_menu: food_menu}
    end

    test "get_food_menu!/1 returns the food menu with given id", %{food_menu: food_menu} do

      assert FoodMenuRepo.get_food_menu!(food_menu.id) == food_menu
    end

    test "list_active_food_menus_from_seller/1 returns all active food menus with given seller_id", %{food_menu: food_menu} do
      assert FoodMenuRepo.list_active_food_menus_from_seller(food_menu.seller_id) == [food_menu]
    end

    test "create_food_menu/1 with valid data creates a food menu" do

      seller = SellerRepoFixtures.seller_fixture()

      valid_attrs = %{description: "some description", ingredients: ["egg", "milk"], menu_illustration: "some menu_illustration", name: "some name", preparation_time_in_minutes: 50, price: 9.5, valid_until: ~U[2100-11-30 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.create_food_menu(valid_attrs, seller.id)
      assert food_menu.seller_id == seller.id
      assert food_menu.allergens == []
      assert food_menu.description == "some description"
      assert food_menu.ingredients == ["egg", "milk"]
      assert food_menu.menu_illustration == "some menu_illustration"
      assert food_menu.name == "some name"
      assert food_menu.preparation_time_in_minutes == 50
      assert food_menu.price == Decimal.new("9.5")
      assert food_menu.rebate == nil
      assert food_menu.valid_until == ~U[2100-11-30 14:28:00Z]
    end

    test "create_food_menu/1 with invalid data returns error changeset" do
      seller = SellerRepoFixtures.seller_fixture()
      invalid_attrs = %{description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}
      assert {:error, %Ecto.Changeset{}} = FoodMenuRepo.create_food_menu(invalid_attrs, seller.id)
    end

    test "update_food_menu/2 with valid data updates the food menu", %{food_menu: food_menu} do
      update_attrs = %{allergens: ["gluten"], description: "some updated description", ingredients: ["sugar", "wheat flour"], menu_illustration: "some updated menu_illustration", name: "some updated name", preparation_time_in_minutes: 45, price: 11.25, rebate: %{}, valid_until: ~U[2100-10-31 14:28:00Z]}

      assert {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.update_food_menu(update_attrs, food_menu.id)
      assert food_menu.allergens == ["gluten"]
      assert food_menu.description == "some updated description"
      assert food_menu.ingredients == ["sugar", "wheat flour"]
      assert food_menu.menu_illustration == "some updated menu_illustration"
      assert food_menu.name == "some updated name"
      assert food_menu.preparation_time_in_minutes == 45
      assert food_menu.price == Decimal.new("11.25")
      assert food_menu.rebate == %{}
      assert food_menu.valid_until == ~U[2100-10-31 14:28:00Z]
    end

    test "update_food_menu/2 with invalid data returns error changeset", %{food_menu: food_menu} do
      assert {:error, %Ecto.Changeset{}} = FoodMenuRepo.update_food_menu(@invalid_attrs, food_menu.id)
      assert food_menu == FoodMenuRepo.get_food_menu!(food_menu.id)
    end

    test "delete_food_menu/1 deletes the food menu", %{food_menu: food_menu} do
      assert {:ok, %FoodMenu{}} = FoodMenuRepo.delete_food_menu(food_menu.id)
      assert_raise Ecto.NoResultsError, fn -> FoodMenuRepo.get_food_menu!(food_menu.id) end
    end

    test "change_food_menu/1 returns a food menu changeset", %{food_menu: food_menu} do
      assert %Ecto.Changeset{} = FoodMenuRepo.change_food_menu(food_menu)
    end
end
