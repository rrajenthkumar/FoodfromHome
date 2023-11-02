defmodule FoodFromHomeWeb.CartItemJSON do
  alias FoodFromHome.CartItems.CartItem

  @doc """
  Renders a list of cart_items.
  """
  def index(%{cart_items: cart_items}) do
    %{data: for(cart_item <- cart_items, do: data(cart_item))}
  end

  @doc """
  Renders a single cart_item.
  """
  def show(%{cart_item: cart_item}) do
    %{data: data(cart_item)}
  end

  defp data(%CartItem{} = cart_item) do
    %{
      id: cart_item.id,
      count: cart_item.count,
      remark: cart_item.remark
    }
  end
end
