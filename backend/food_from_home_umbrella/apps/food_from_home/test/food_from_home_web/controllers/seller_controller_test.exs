defmodule FoodFromHomeWeb.SellerControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.FoodMenus.SellerRepoFixtures

  alias FoodFromHome.Sellers.Seller

  @create_attrs %{
    illustration: "some illustration",
    introduction: "some introduction",
    tax_id: "some tax_id"
  }
  @update_attrs %{
    illustration: "some updated illustration",
    introduction: "some updated introduction",
    tax_id: "some updated tax_id"
  }
  @invalid_attrs %{illustration: nil, introduction: nil, tax_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sellers", %{conn: conn} do
      conn = get(conn, ~p"/api/sellers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create seller" do
    test "renders seller when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/sellers", seller: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/sellers/#{id}")

      assert %{
               "id" => ^id,
               "illustration" => "some illustration",
               "introduction" => "some introduction",
               "tax_id" => "some tax_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/sellers", seller: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update seller" do
    setup [:create_seller]

    test "renders seller when data is valid", %{conn: conn, seller: %Seller{id: id} = seller} do
      conn = put(conn, ~p"/api/sellers/#{seller}", seller: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/sellers/#{id}")

      assert %{
               "id" => ^id,
               "illustration" => "some updated illustration",
               "introduction" => "some updated introduction",
               "tax_id" => "some updated tax_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, seller: seller} do
      conn = put(conn, ~p"/api/sellers/#{seller}", seller: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete seller" do
    setup [:create_seller]

    test "deletes chosen seller", %{conn: conn, seller: seller} do
      conn = delete(conn, ~p"/api/sellers/#{seller}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/sellers/#{seller}")
      end
    end
  end

  defp create_seller(_) do
    seller = seller_fixture()
    %{seller: seller}
  end
end
