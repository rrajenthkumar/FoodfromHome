defmodule FoodFromHomeWeb.FoodMenuControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.FoodMenus.FoodMenuRepoFixtures

  @create_attrs %{
    description: "some description",
    ingredients: ["egg", "milk"],
    menu_illustration: "some menu_illustration",
    name: "some name",
    preparation_time_in_minutes: 42,
    price: "120.5",
    valid_until: ~U[2023-11-01 10:30:00Z]
  }
  @update_attrs %{
    allergens: ["gluten"],
    description: "some updated description",
    ingredients: ["sugar", "wheat flour"],
    menu_illustration: "some updated menu_illustration",
    name: "some updated name",
    preparation_time_in_minutes: 43,
    price: "456.7",
    rebate: %{},
    valid_until: ~U[2023-11-02 10:30:00Z]
  }
  @invalid_attrs %{seller_id: nil, description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, valid_until: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_food_menu_for_retrieval]

    test "lists all active food menus from seller", %{conn: conn, seller_id: seller_id} do
      conn = get(conn, ~p"/api/v1/food_menus/#{seller_id}")
      assert json_response(conn, 200)["data"] == [%{"seller_id" => seller_id}]
    end
  end

  describe "create a food menu" do
    test "renders food menu when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/food_menus", food_menu: @create_attrs)
      assert %{"id" => menu_id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/food_menus/#{menu_id}")

      assert %{
               "id" => ^menu_id,
               "allergens" => [],
               "description" => "some description",
               "ingredients" => "egg",
               "menu_illustration" => "some menu_illustration",
               "name" => "some name",
               "preparation_time_in_minutes" => 42,
               "price" => "120.5",
               "rebate" => nil,
               "valid_until" => "2023-11-01T10:30:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/food_menus", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update a food_menu" do
    setup [:create_food_menu]

    test "renders food menu when data is valid", %{conn: conn, menu_id: menu_id} do
      conn = put(conn, ~p"/api/v1/food_menus/#{menu_id}", food_menu: @update_attrs)
      assert %{"id" => ^menu_id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/food_menus/#{menu_id}")

      assert %{
               "id" => ^menu_id,
               "allergens" => ["gluten"],
               "description" => "some updated description",
               "ingredients" => ["sugar", "wheat flour"],
               "menu_illustration" => "some updated menu_illustration",
               "name" => "some updated name",
               "preparation_time_in_minutes" => 43,
               "price" => "456.7",
               "rebate" => %{},
               "valid_until" => "2023-11-02T10:30:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, menu_id: menu_id} do
      conn = put(conn, ~p"/api/v1/food_menus/#{menu_id}", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete a food_menu" do
    setup [:create_food_menu]

    test "deletes a chosen food menu", %{conn: conn, menu_id: menu_id} do
      conn = delete(conn, ~p"/api/v1/food_menus/#{menu_id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/food_menus/#{menu_id}")
      end
    end
  end

  defp create_food_menu(_) do
    food_menu = food_menu_fixture()
    %{menu_id: food_menu.id}
  end

  defp create_food_menu_for_retrieval(_) do
    food_menu = food_menu_fixture()
    %{seller_id: food_menu.seller_id}
  end
end
