defmodule FoodFromHome.FoodMenus.FoodMenuRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.FoodMenus.FoodMenuRepo
  alias FoodFromHome.Sellers.SellerRepoFixtures

    @invalid_attrs %{description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}

    setup do
      seller_1 = SellerRepoFixtures.seller_fixture()

      valid_attrs_1 = %{description: "some description", ingredients: ["egg", "honey"], menu_illustration: "some menu_illustration", name: "some name", preparation_time_in_minutes: 15, price: 5, valid_until: ~U[2100-11-25 14:28:00Z]}
      {:ok, %FoodMenu{} = food_menu_1} = FoodMenuRepo.create_food_menu(valid_attrs_1, seller_1.id)

      seller_2 = SellerRepoFixtures.seller_fixture()

      valid_attrs_2 = %{description: "some another description", ingredients: ["butter", "milk"], menu_illustration: "some another menu_illustration", name: "some another name", preparation_time_in_minutes: 25, price: 6.5, valid_until: ~U[2023-11-12 14:28:00Z]}

      {:ok, %FoodMenu{} = food_menu_2} = FoodMenuRepo.create_food_menu(valid_attrs_2, seller_2.id)

      valid_attrs_3 = %{description: "some another description", ingredients: ["butter", "onion"], menu_illustration: "some another new menu_illustration", name: "some another new name", preparation_time_in_minutes: 30, price: 9.25, valid_until: ~U[2100-05-06 14:28:00Z]}

      {:ok, %FoodMenu{} = food_menu_3} = FoodMenuRepo.create_food_menu(valid_attrs_3, seller_2.id)

      %{food_menu_1: food_menu_1, food_menu_2: food_menu_2, food_menu_3: food_menu_3}
    end

    test "get_food_menu!/1 returns the food menu with given id", %{food_menu_1: food_menu} do

      assert FoodMenuRepo.get_food_menu!(food_menu.id) == food_menu
    end

    test "create_food_menu/1 with valid data creates a food menu" do

      seller = SellerRepoFixtures.seller_fixture()
      valid_attrs = %{description: "some description", ingredients: ["egg", "milk"], menu_illustration: "some menu_illustration", name: "some name", preparation_time_in_minutes: 50, price: 9.5, valid_until: ~U[2100-11-30 14:28:00Z]}

      {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.create_food_menu(valid_attrs, seller.id)

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

    test "update_food_menu/2 with valid data updates the food menu", %{food_menu_2: food_menu} do
      update_attrs = %{allergens: ["gluten"], description: "some updated description", ingredients: ["sugar", "wheat flour"], menu_illustration: "some updated menu_illustration", name: "some updated name", preparation_time_in_minutes: 45, price: 11.25, rebate: %{}, valid_until: ~U[2100-10-31 14:28:00Z]}

      {:ok, %FoodMenu{} = food_menu} = FoodMenuRepo.update_food_menu(update_attrs, food_menu.id)

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

    test "update_food_menu/2 with invalid data returns error changeset", %{food_menu_2: food_menu} do
      assert {:error, %Ecto.Changeset{}} = FoodMenuRepo.update_food_menu(@invalid_attrs, food_menu.id)
      assert food_menu == FoodMenuRepo.get_food_menu!(food_menu.id)
    end

    test "delete_food_menu/1 deletes the food menu", %{food_menu_3: food_menu} do
      assert {:ok, %FoodMenu{}} = FoodMenuRepo.delete_food_menu(food_menu.id)
      assert_raise Ecto.NoResultsError, fn -> FoodMenuRepo.get_food_menu!(food_menu.id) end
    end

    test "change_food_menu/1 returns a food menu changeset", %{food_menu_3: food_menu} do
      assert %Ecto.Changeset{} = FoodMenuRepo.change_food_menu(food_menu)
    end

    describe "list_food_menus/1" do
      test "lists all food menus", %{food_menu_1: food_menu_1, food_menu_2: food_menu_2, food_menu_3: food_menu_3} do
        assert FoodMenuRepo.list_food_menus(_filter_params = %{}) == [food_menu_1, food_menu_2, food_menu_3]
      end

      test "lists only food menus for a given seller_id", %{food_menu_2: food_menu_2, food_menu_3: food_menu_3} do
        assert FoodMenuRepo.list_food_menus(_filter_params = %{seller_id: food_menu_3.seller_id}) == [food_menu_2, food_menu_3]
      end

      test "lists only active food menus for a given seller_id", %{food_menu_3: food_menu_3} do
        assert FoodMenuRepo.list_food_menus(_filter_params = %{seller_id: food_menu_3.seller_id, active: "true"}) == [food_menu_3]
      end
    end
end
