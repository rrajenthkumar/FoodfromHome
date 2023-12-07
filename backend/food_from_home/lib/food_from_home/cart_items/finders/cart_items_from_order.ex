defmodule FoodFromHome.CartItems.Finders.CartItemsFromOrder do
  @moduledoc """
  Finder to list cart items from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Returns a list of cart items for an order.

  ## Examples

    iex> list(%Order{})
    [%CartItem{}, ...]

  """
  def list(%Order{id: order_id}) do
    query =
      from(cart_item in CartItem,
        join: order in assoc(cart_item, :order),
        where: order.id == ^order_id)

    Repo.all(query)
  end
end
