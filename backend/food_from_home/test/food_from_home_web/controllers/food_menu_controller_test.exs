defmodule FoodFromHomeWeb.FoodMenuControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.FoodMenusFixtures

  alias FoodFromHome.FoodMenus.FoodMenu

  @create_attrs %{
    allergens: :lactose,
    description: "some description",
    ingredients: :egg,
    menu_illustration: "some menu_illustration",
    name: "some name",
    preparation_time_in_minutes: 42,
    price: "120.5",
    rebate: %{},
    valid_until: ~U[2023-11-01 10:30:00Z]
  }
  @update_attrs %{
    allergens: :gluten,
    description: "some updated description",
    ingredients: :sugar,
    menu_illustration: "some updated menu_illustration",
    name: "some updated name",
    preparation_time_in_minutes: 43,
    price: "456.7",
    rebate: %{},
    valid_until: ~U[2023-11-02 10:30:00Z]
  }
  @invalid_attrs %{allergens: nil, description: nil, ingredients: nil, menu_illustration: nil, name: nil, preparation_time_in_minutes: nil, price: nil, rebate: nil, valid_until: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all food_menus", %{conn: conn} do
      conn = get(conn, ~p"/api/food_menus")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create food_menu" do
    test "renders food_menu when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/food_menus", food_menu: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/food_menus/#{id}")

      assert %{
               "id" => ^id,
               "allergens" => "lactose",
               "description" => "some description",
               "ingredients" => "egg",
               "menu_illustration" => "some menu_illustration",
               "name" => "some name",
               "preparation_time_in_minutes" => 42,
               "price" => "120.5",
               "rebate" => %{},
               "valid_until" => "2023-11-01T10:30:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/food_menus", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update food_menu" do
    setup [:create_food_menu]

    test "renders food_menu when data is valid", %{conn: conn, food_menu: %FoodMenu{id: id} = food_menu} do
      conn = put(conn, ~p"/api/food_menus/#{food_menu}", food_menu: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/food_menus/#{id}")

      assert %{
               "id" => ^id,
               "allergens" => "gluten",
               "description" => "some updated description",
               "ingredients" => "sugar",
               "menu_illustration" => "some updated menu_illustration",
               "name" => "some updated name",
               "preparation_time_in_minutes" => 43,
               "price" => "456.7",
               "rebate" => %{},
               "valid_until" => "2023-11-02T10:30:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, food_menu: food_menu} do
      conn = put(conn, ~p"/api/food_menus/#{food_menu}", food_menu: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete food_menu" do
    setup [:create_food_menu]

    test "deletes chosen food_menu", %{conn: conn, food_menu: food_menu} do
      conn = delete(conn, ~p"/api/food_menus/#{food_menu}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/food_menus/#{food_menu}")
      end
    end
  end

  defp create_food_menu(_) do
    food_menu = food_menu_fixture()
    %{food_menu: food_menu}
  end
end
