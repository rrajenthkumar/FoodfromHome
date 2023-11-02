defmodule FoodFromHomeWeb.OrderJSON do
  alias FoodFromHome.Orders.Order

  @doc """
  Renders a list of orders.
  """
  def index(%{orders: orders}) do
    %{data: for(order <- orders, do: data(order))}
  end

  @doc """
  Renders a single order.
  """
  def show(%{order: order}) do
    %{data: data(order)}
  end

  defp data(%Order{} = order) do
    %{
      id: order.id,
      date: order.date,
      delivery_address: order.delivery_address,
      invoice_link: order.invoice_link,
      status: order.status
    }
  end
end
