defmodule FoodFromHomeWeb.FoodMenuControllerTest do
  use FoodFromHomeWeb.ConnCase

  alias FoodFromHome.FoodMenus.FoodMenuRepoFixtures
  alias FoodFromHome.Sellers.SellerRepoFixtures

  @create_attrs %{
    description: "some new description",
    ingredients: ["egg", "milk"],
    menu_illustration: "some new menu_illustration",
    name: "some new name",
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
  @invalid_attrs %{description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_food_menu]

    test "lists all active food menus from seller", %{conn: conn, menu_id: menu_id, seller_id: seller_id} do
      conn = get(conn, ~p"/api/v1/sellers/#{seller_id}/food-menus")

      assert json_response(conn, 200)["data"] == [
      %{"id" => menu_id,
      "allergens" => ["lactose"],
      "description" => "some description",
      "ingredients" => ["egg", "butter"],
      "menu_illustration" => "some menu_illustration",
      "name" => "some name",
      "price" => "12.5",
      "rebate" => %{},
      "preparation_time_in_minutes" => 42,
      "valid_until" => "2100-10-30T14:28:00Z"}
    ]
    end
  end

  describe "create" do
    setup [:create_seller]

    test "creates and renders a food menu when data is valid", %{conn: conn, seller_id: seller_id} do
      conn = post(conn, ~p"/api/v1/sellers/#{seller_id}/food-menus", food_menu: @create_attrs)

      %{"id" => menu_id} = json_response(conn, 201)["data"]

      assert json_response(conn, 201)["data"] == %{
        "id" => menu_id,
         "allergens" => [],
         "description" => "some new description",
         "ingredients" => ["egg", "milk"],
         "menu_illustration" => "some new menu_illustration",
         "name" => "some new name",
         "preparation_time_in_minutes" => 60,
         "price" => "5.75",
         "rebate" => nil,
         "valid_until" => "2100-11-02T10:30:00Z"
       }

      conn = get(conn, ~p"/api/v1/food-menus/#{menu_id}")

      assert json_response(conn, 200)["data"] == %{
              "id" => menu_id,
               "allergens" => [],
               "description" => "some new description",
               "ingredients" => ["egg", "milk"],
               "menu_illustration" => "some new menu_illustration",
               "name" => "some new name",
               "preparation_time_in_minutes" => 60,
               "price" => "5.75",
               "rebate" => nil,
               "valid_until" => "2100-11-02T10:30:00Z"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, seller_id: seller_id} do
      conn = post(conn, ~p"/api/v1/sellers/#{seller_id}/food-menus", food_menu: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show" do
    setup [:create_food_menu]

    test "renders food menu when a menu for a given menu_id exists", %{conn: conn, menu_id: menu_id} do
      conn = get(conn, ~p"/api/v1/food-menus/#{menu_id}")

      assert json_response(conn, 200)["data"] == %{
      "id" => menu_id,
      "allergens" => ["lactose"],
      "description" => "some description",
      "ingredients" => ["egg", "butter"],
      "menu_illustration" => "some menu_illustration",
      "name" => "some name",
      "price" => "12.5",
      "rebate" => %{},
      "preparation_time_in_minutes" => 42,
      "valid_until" => "2100-10-30T14:28:00Z"}
    end

    test "renders errors when a menu for a given menu_id does not exist", %{conn: conn, menu_id: menu_id} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food-menus/#{menu_id + 1}")
      end
    end
  end

  describe "update" do
    setup [:create_food_menu]

    test "renders food menu when data is valid", %{conn: conn, menu_id: menu_id} do
      conn = put(conn, ~p"/api/v1/food-menus/#{menu_id}", food_menu: @update_attrs)
      assert json_response(conn, 200)["data"] == %{
        "id" => menu_id,
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

      conn = get(conn, ~p"/api/v1/food-menus/#{menu_id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => menu_id,
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

    test "renders errors when data is invalid", %{conn: conn, menu_id: menu_id, seller_id: _seller_id} do
      conn = put(conn, ~p"/api/v1/food-menus/#{menu_id}", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete a food_menu" do
    setup [:create_food_menu]

    test "deletes a chosen food menu", %{conn: conn, menu_id: menu_id} do
      conn = delete(conn, ~p"/api/v1/food-menus/#{menu_id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food-menus/#{menu_id}")
      end
    end
  end

  defp create_food_menu(_) do
    food_menu = FoodMenuRepoFixtures.food_menu_fixture()
    %{menu_id: food_menu.id, seller_id: food_menu.seller_id}
  end

  defp create_seller(_) do
    seller = SellerRepoFixtures.seller_fixture()
    %{seller_id: seller.id}
  end
end
