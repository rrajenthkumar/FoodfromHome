defmodule FoodFromHome.OrdersTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Orders

  describe "orders" do
    alias FoodFromHome.Orders.Order
    alias FoodFromHome.Orders.OrderRepo

    import FoodFromHome.OrdersFixtures

    @invalid_attrs %{date: nil, delivery_address: nil, invoice_link: nil, status: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        date: ~U[2023-10-30 14:37:00Z],
        delivery_address: %{},
        invoice_link: "some invoice_link",
        status: :open
      }

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.date == ~U[2023-10-30 14:37:00Z]
      assert order.delivery_address == %{}
      assert order.invoice_link == "some invoice_link"
      assert order.status == :open
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        date: ~U[2023-10-31 14:37:00Z],
        delivery_address: %{},
        invoice_link: "some updated invoice_link",
        status: :confirmed
      }

      assert {:ok, %Order{} = order} = OrderRepo.update_order(order, update_attrs)
      assert order.date == ~U[2023-10-31 14:37:00Z]
      assert order.delivery_address == %{}
      assert order.invoice_link == "some updated invoice_link"
      assert order.status == :confirmed
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderRepo.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
