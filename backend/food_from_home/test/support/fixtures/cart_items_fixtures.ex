defmodule FoodFromHome.CartItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.CartItems` context.
  """

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        count: 42,
        remark: "some remark"
      })
      |> FoodFromHome.CartItems.create_cart_item()

    cart_item
  end
end
