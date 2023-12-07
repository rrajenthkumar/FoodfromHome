defmodule FoodFromHome.CartItems do
  @moduledoc """
  The CartItems context.
  """
  alias FoodFromHome.CartItems.CartItemRepo
  alias FoodFromHome.CartItems.Finders.CartItemsFromOrder

  defdelegate create(order, attrs), to: CartItemRepo
  defdelegate update(cart_item, attrs), to: CartItemRepo
  defdelegate delete(cart_item), to: CartItemRepo

  def list_cart_items_from_order(order), do: CartItemsFromOrder.list(order)
end
