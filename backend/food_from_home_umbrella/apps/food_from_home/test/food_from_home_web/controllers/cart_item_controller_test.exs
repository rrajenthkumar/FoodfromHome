defmodule FoodFromHomeWeb.CartItemControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.CartItemsFixtures

  alias FoodFromHome.CartItems.CartItem

  @create_attrs %{
    count: 42,
    remark: "some remark"
  }
  @update_attrs %{
    count: 43,
    remark: "some updated remark"
  }
  @invalid_attrs %{count: nil, remark: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cart_items", %{conn: conn} do
      conn = get(conn, ~p"/api/cart_items")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cart_item" do
    test "renders cart_item when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/cart_items", cart_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/cart_items/#{id}")

      assert %{
               "id" => ^id,
               "count" => 42,
               "remark" => "some remark"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/cart_items", cart_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cart_item" do
    setup [:create_cart_item]

    test "renders cart_item when data is valid", %{
      conn: conn,
      cart_item: %CartItem{id: id} = cart_item
    } do
      conn = put(conn, ~p"/api/cart_items/#{cart_item}", cart_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/cart_items/#{id}")

      assert %{
               "id" => ^id,
               "count" => 43,
               "remark" => "some updated remark"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, cart_item: cart_item} do
      conn = put(conn, ~p"/api/cart_items/#{cart_item}", cart_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cart_item" do
    setup [:create_cart_item]

    test "deletes chosen cart_item", %{conn: conn, cart_item: cart_item} do
      conn = delete(conn, ~p"/api/cart_items/#{cart_item}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/cart_items/#{cart_item}")
      end
    end
  end

  defp create_cart_item(_) do
    cart_item = cart_item_fixture()
    %{cart_item: cart_item}
  end
end
