defmodule FoodFromHome.DeliveriesTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Deliveries

  describe "deliveries" do
    alias FoodFromHome.Deliveries.Delivery

    import FoodFromHome.DeliveriesFixtures

    @invalid_attrs %{delivered_at: nil, distance_travelled_in_kms: nil, picked_up_at: nil, current_position: nil}

    test "list_deliveries/0 returns all deliveries" do
      delivery = delivery_fixture()
      assert Deliveries.list_deliveries() == [delivery]
    end

    test "get_delivery!/1 returns the delivery with given id" do
      delivery = delivery_fixture()
      assert Deliveries.get_delivery!(delivery.id) == delivery
    end

    test "create_delivery/1 with valid data creates a delivery" do
      valid_attrs = %{delivered_at: ~U[2023-11-02 08:23:00Z], distance_travelled_in_kms: "120.5", picked_up_at: ~U[2023-11-02 08:23:00Z], current_position: %Geo.Point{coordinates: {30, -90}, srid: 4326}}

      assert {:ok, %Delivery{} = delivery} = Deliveries.create_delivery(valid_attrs)
      assert delivery.delivered_at == ~U[2023-11-02 08:23:00Z]
      assert delivery.distance_travelled_in_kms == Decimal.new("120.5")
      assert delivery.picked_up_at == ~U[2023-11-02 08:23:00Z]
      assert delivery.current_position == %Geo.Point{coordinates: {30, -90}, srid: 4326}
    end

    test "create_delivery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deliveries.create_delivery(@invalid_attrs)
    end

    test "update_delivery/2 with valid data updates the delivery" do
      delivery = delivery_fixture()
      update_attrs = %{delivered_at: ~U[2023-11-03 08:23:00Z], distance_travelled_in_kms: "456.7", picked_up_at: ~U[2023-11-03 08:23:00Z], current_position: %Geo.Point{coordinates: {70, -40}, srid: 4100}}

      assert {:ok, %Delivery{} = delivery} = Deliveries.update_delivery(delivery, update_attrs)
      assert delivery.delivered_at == ~U[2023-11-03 08:23:00Z]
      assert delivery.distance_travelled_in_kms == Decimal.new("456.7")
      assert delivery.picked_up_at == ~U[2023-11-03 08:23:00Z]
      assert delivery.current_position == %Geo.Point{coordinates: {70, -40}, srid: 4100}
    end

    test "update_delivery/2 with invalid data returns error changeset" do
      delivery = delivery_fixture()
      assert {:error, %Ecto.Changeset{}} = Deliveries.update_delivery(delivery, @invalid_attrs)
      assert delivery == Deliveries.get_delivery!(delivery.id)
    end

    test "delete_delivery/1 deletes the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{}} = Deliveries.delete_delivery(delivery)
      assert_raise Ecto.NoResultsError, fn -> Deliveries.get_delivery!(delivery.id) end
    end

    test "change_delivery/1 returns a delivery changeset" do
      delivery = delivery_fixture()
      assert %Ecto.Changeset{} = Deliveries.change_delivery(delivery)
    end
  end
end
