defmodule FoodFromHomeWeb.OrderJSON do
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.Order.DeliveryAddress

  @doc """
  Renders a list of orders with limited details.
  """
  def index(%{orders: orders}) do
    %{data: for(order <- orders, do: limited_data(order))}
  end

  @doc """
  Renders a single order with all details.
  """
  def show(%{order: order}) do
    %{data: data(order)}
  end

  defp limited_data(order = %Order{}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status,
      seller_id: order.seller_id,
      buyer_user_id: order.buyer_user_id
    }
  end

  defp data(order = %Order{}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status,
      seller_id: order.seller_id,
      buyer_user_id: order.buyer_user_id,
      delivery_address: data(order.delivery_address),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark
    }
  end

  defp data(delivery_address = %DeliveryAddress{}) do
    %{
      door_number: delivery_address.door_number,
      street: delivery_address.street,
      city: delivery_address.city,
      country: delivery_address.country,
      postal_code: delivery_address.postal_code
    }
  end
end
