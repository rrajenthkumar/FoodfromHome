defmodule FoodFromHome.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        date: ~U[2023-10-30 14:37:00Z],
        delivery_address: %{},
        invoice_link: "some invoice_link",
        status: :open
      })
      |> FoodFromHome.Orders.create_order()

    order
  end
end
