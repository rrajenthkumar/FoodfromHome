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

  # When there is a food_menu preload
  defp data(%CartItem{food_menu: %FoodMenu{}} = cart_item) do
    %{
      id: cart_item.id,
      count: cart_item.count,
      remark: cart_item.remark,
      food_menu: limited_data(cart_item.food_menu)
    }
  end

  defp data(%CartItem{} = cart_item) do
    %{
      id: cart_item.id,
      count: cart_item.count,
      remark: cart_item.remark
    }
  end

  defp limited_data(%FoodMenu{} = food_menu) do
    %{
      id: food_menu.id,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate
    }
  end
end
