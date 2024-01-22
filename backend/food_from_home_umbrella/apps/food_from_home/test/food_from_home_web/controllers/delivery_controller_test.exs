defmodule FoodFromHomeWeb.DeliveryControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.DeliveriesFixtures

  alias FoodFromHome.Deliveries.Delivery

  @create_attrs %{
    delivered_at: ~U[2023-11-02 08:23:00Z],
    distance_travelled_in_kms: "120.5",
    picked_up_at: ~U[2023-11-02 08:23:00Z],
    current_geoposition: %Geo.Point{coordinates: {20, -10}, srid: 2200}
  }
  @update_attrs %{
    delivered_at: ~U[2023-11-03 08:23:00Z],
    distance_travelled_in_kms: "456.7",
    picked_up_at: ~U[2023-11-03 08:23:00Z],
    current_geoposition: %Geo.Point{coordinates: {10, -90}, srid: 5420}
  }
  @invalid_attrs %{
    delivered_at: nil,
    distance_travelled_in_kms: nil,
    picked_up_at: nil,
    current_geoposition: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all deliveries", %{conn: conn} do
      conn = get(conn, ~p"/api/deliveries")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create delivery" do
    test "renders delivery when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/deliveries", delivery: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/deliveries/#{id}")

      assert %{
               "id" => ^id,
               "delivered_at" => "2023-11-02T08:23:00Z",
               "distance_travelled_in_kms" => "120.5",
               "picked_up_at" => "2023-11-02T08:23:00Z",
               "current_geoposition" => %{"coordinates" => {"20", "-10"}, "srid" => "2200"}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/deliveries", delivery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update delivery" do
    setup [:create_delivery]

    test "renders delivery when data is valid", %{
      conn: conn,
      delivery: %Delivery{id: id} = delivery
    } do
      conn = put(conn, ~p"/api/deliveries/#{delivery}", delivery: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/deliveries/#{id}")

      assert %{
               "id" => ^id,
               "delivered_at" => "2023-11-03T08:23:00Z",
               "distance_travelled_in_kms" => "456.7",
               "picked_up_at" => "2023-11-03T08:23:00Z",
               "current_geoposition" => %{"coordinates" => {"10", "-90"}, "srid" => "5420"}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, delivery: delivery} do
      conn = put(conn, ~p"/api/deliveries/#{delivery}", delivery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete delivery" do
    setup [:create_delivery]

    test "deletes chosen delivery", %{conn: conn, delivery: delivery} do
      conn = delete(conn, ~p"/api/deliveries/#{delivery}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/deliveries/#{delivery}")
      end
    end
  end

  defp create_delivery(_) do
    delivery = delivery_fixture()
    %{delivery: delivery}
  end
end
