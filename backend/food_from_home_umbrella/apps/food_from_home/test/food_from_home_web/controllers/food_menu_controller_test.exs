defmodule FoodFromHomeWeb.FoodMenuControllerTest do
  use FoodFromHomeWeb.ConnCase

  alias FoodFromHome.FoodMenus.FoodMenuRepoFixtures
  alias FoodFromHome.Sellers.SellerRepoFixtures

  @create_attrs %{
    description: "some description",
    ingredients: ["egg", "milk"],
    menu_illustration: "some menu_illustration",
    name: "some name",
    preparation_time_in_minutes: 60,
    price: 5.75,
    valid_until: ~U[2100-11-02 10:30:00Z]
  }

  @update_attrs %{
    allergens: ["gluten"],
    description: "some updated description",
    ingredients: ["sugar", "wheat flour"],
    menu_illustration: "some updated menu_illustration",
    name: "some updated name",
    preparation_time_in_minutes: 43,
    price: 10.25,
    rebate: %{},
    valid_until: ~U[2100-11-03 10:30:00Z]
  }

  @invalid_attrs %{
    description: nil,
    ingredients: nil,
    menu_illustration: nil,
    name: nil,
    preparation_time_in_minutes: nil,
    price: nil,
    valid_until: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    setup [:create_seller]

    test "creates and renders a food menu when data is valid", %{conn: conn, seller: seller} do
      conn = post(conn, ~p"/api/v1/sellers/#{seller.id}/food-menus", food_menu: @create_attrs)

      %{"id" => food_menu_id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/food-menus/#{food_menu_id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => food_menu_id,
               "seller_id" => seller.id,
               "allergens" => [],
               "description" => "some description",
               "ingredients" => ["egg", "milk"],
               "menu_illustration" => "some menu_illustration",
               "name" => "some name",
               "preparation_time_in_minutes" => 60,
               "price" => "5.75",
               "rebate" => nil,
               "valid_until" => "2100-11-02T10:30:00Z"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, seller: seller} do
      conn = post(conn, ~p"/api/v1/sellers/#{seller.id}/food-menus", food_menu: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show" do
    setup [:create_food_menu]

    test "renders food menu when a menu for a given menu_id exists", %{
      conn: conn,
      food_menu: food_menu
    } do
      conn = get(conn, ~p"/api/v1/food-menus/#{food_menu.id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => food_menu.id,
               "seller_id" => food_menu.seller_id,
               "allergens" => ["lactose"],
               "description" => "some description",
               "ingredients" => ["egg", "butter"],
               "menu_illustration" => "some menu_illustration",
               "name" => "some name",
               "price" => "12.5",
               "rebate" => %{},
               "preparation_time_in_minutes" => 42,
               "valid_until" => "2100-10-30T14:28:00Z"
             }
    end

    test "renders errors when a menu for a given menu_id does not exist", %{
      conn: conn,
      food_menu: food_menu
    } do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food-menus/#{food_menu.id + 1}")
      end
    end
  end

  describe "update" do
    setup [:create_food_menu]

    test "updates and renders food menu when data is valid", %{conn: conn, food_menu: food_menu} do
      conn = put(conn, ~p"/api/v1/food-menus/#{food_menu.id}", food_menu: @update_attrs)

      assert json_response(conn, 200)["data"] == %{
               "id" => food_menu.id,
               "seller_id" => food_menu.seller_id,
               "allergens" => ["gluten"],
               "description" => "some updated description",
               "ingredients" => ["sugar", "wheat flour"],
               "menu_illustration" => "some updated menu_illustration",
               "name" => "some updated name",
               "price" => "10.25",
               "rebate" => %{},
               "preparation_time_in_minutes" => 43,
               "valid_until" => "2100-11-03T10:30:00Z"
             }

      conn = get(conn, ~p"/api/v1/food-menus/#{food_menu.id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => food_menu.id,
               "seller_id" => food_menu.seller_id,
               "allergens" => ["gluten"],
               "description" => "some updated description",
               "ingredients" => ["sugar", "wheat flour"],
               "menu_illustration" => "some updated menu_illustration",
               "name" => "some updated name",
               "price" => "10.25",
               "rebate" => %{},
               "preparation_time_in_minutes" => 43,
               "valid_until" => "2100-11-03T10:30:00Z"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, food_menu: food_menu} do
      conn = put(conn, ~p"/api/v1/food-menus/#{food_menu.id}", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete a food_menu" do
    setup [:create_food_menu]

    test "deletes a chosen food menu", %{conn: conn, food_menu: food_menu} do
      conn = delete(conn, ~p"/api/v1/food-menus/#{food_menu.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food-menus/#{food_menu.id}")
      end
    end
  end

  describe "lists food menus" do
    setup do
      seller_1 = SellerRepoFixtures.seller_fixture()
      food_menu_1 = FoodMenuRepoFixtures.food_menu_fixture(%{}, seller_1.id)

      seller_2 = SellerRepoFixtures.seller_fixture()

      valid_attrs_2 = %{
        description: "some another description",
        allergens: ["gluten"],
        ingredients: ["butter", "milk", "wheat flour"],
        menu_illustration: "some another menu_illustration",
        name: "some another name",
        preparation_time_in_minutes: 25,
        price: 6.5,
        valid_until: ~U[2023-11-12 14:28:00Z]
      }

      food_menu_2 = FoodMenuRepoFixtures.food_menu_fixture(valid_attrs_2, seller_2.id)

      valid_attrs_3 = %{
        description: "some another new description",
        allergens: [],
        ingredients: ["butter", "onion"],
        menu_illustration: "some another new menu_illustration",
        name: "some another new name",
        preparation_time_in_minutes: 30,
        price: 9.25,
        valid_until: ~U[2100-05-06 14:28:00Z]
      }

      food_menu_3 = FoodMenuRepoFixtures.food_menu_fixture(valid_attrs_3, seller_2.id)

      %{food_menu_1: food_menu_1, food_menu_2: food_menu_2, food_menu_3: food_menu_3}
    end

    test "lists all food menus", %{
      conn: conn,
      food_menu_1: food_menu_1,
      food_menu_2: food_menu_2,
      food_menu_3: food_menu_3
    } do
      conn = get(conn, ~p"/api/v1/food-menus/")

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => food_menu_1.id,
                 "seller_id" => food_menu_1.seller_id,
                 "description" => "some description",
                 "ingredients" => ["egg", "butter"],
                 "allergens" => ["lactose"],
                 "menu_illustration" => "some menu_illustration",
                 "name" => "some name",
                 "preparation_time_in_minutes" => 42,
                 "price" => "12.5",
                 "rebate" => %{},
                 "valid_until" => "2100-10-30T14:28:00Z"
               },
               %{
                 "id" => food_menu_2.id,
                 "seller_id" => food_menu_2.seller_id,
                 "allergens" => ["gluten"],
                 "description" => "some another description",
                 "ingredients" => ["butter", "milk", "wheat flour"],
                 "menu_illustration" => "some another menu_illustration",
                 "name" => "some another name",
                 "price" => "6.5",
                 "rebate" => %{},
                 "preparation_time_in_minutes" => 25,
                 "valid_until" => "2023-11-12T14:28:00Z"
               },
               %{
                 "id" => food_menu_3.id,
                 "seller_id" => food_menu_3.seller_id,
                 "allergens" => [],
                 "description" => "some another new description",
                 "ingredients" => ["butter", "onion"],
                 "menu_illustration" => "some another new menu_illustration",
                 "name" => "some another new name",
                 "price" => "9.25",
                 "rebate" => %{},
                 "preparation_time_in_minutes" => 30,
                 "valid_until" => "2100-05-06T14:28:00Z"
               }
             ]
    end

    test "lists food menus for a given seller id", %{
      conn: conn,
      food_menu_2: food_menu_2,
      food_menu_3: food_menu_3
    } do
      # conn = get(conn, ~p"/api/v1/food-menus?seller_id=#{seller_2.id}&valid_until=#{DateTime.utc_now()}")
      conn = get(conn, ~p"/api/v1/food-menus?seller_id=#{food_menu_2.seller_id}")

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => food_menu_2.id,
                 "seller_id" => food_menu_2.seller_id,
                 "allergens" => ["gluten"],
                 "description" => "some another description",
                 "ingredients" => ["butter", "milk", "wheat flour"],
                 "menu_illustration" => "some another menu_illustration",
                 "name" => "some another name",
                 "price" => "6.5",
                 "rebate" => %{},
                 "preparation_time_in_minutes" => 25,
                 "valid_until" => "2023-11-12T14:28:00Z"
               },
               %{
                 "id" => food_menu_3.id,
                 "seller_id" => food_menu_2.seller_id,
                 "allergens" => [],
                 "description" => "some another new description",
                 "ingredients" => ["butter", "onion"],
                 "menu_illustration" => "some another new menu_illustration",
                 "name" => "some another new name",
                 "price" => "9.25",
                 "rebate" => %{},
                 "preparation_time_in_minutes" => 30,
                 "valid_until" => "2100-05-06T14:28:00Z"
               }
             ]
    end

    test "lists active food menus for a given seller id", %{
      conn: conn,
      food_menu_2: food_menu_2,
      food_menu_3: food_menu_3
    } do
      conn = get(conn, ~p"/api/v1/food-menus?seller_id=#{food_menu_2.seller_id}&active=true")

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => food_menu_3.id,
                 "seller_id" => food_menu_2.seller_id,
                 "allergens" => [],
                 "description" => "some another new description",
                 "ingredients" => ["butter", "onion"],
                 "menu_illustration" => "some another new menu_illustration",
                 "name" => "some another new name",
                 "price" => "9.25",
                 "rebate" => %{},
                 "preparation_time_in_minutes" => 30,
                 "valid_until" => "2100-05-06T14:28:00Z"
               }
             ]
    end
  end

  defp create_food_menu(_) do
    food_menu = FoodMenuRepoFixtures.food_menu_fixture()
    %{food_menu: food_menu}
  end

  defp create_seller(_) do
    seller = SellerRepoFixtures.seller_fixture()
    %{seller: seller}
  end
end
