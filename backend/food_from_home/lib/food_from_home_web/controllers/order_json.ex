defmodule FoodFromHomeWeb.OrderJSON do
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.Order.DeliveryAddress
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @doc """
  Renders a list of orders with limited details.
  """
  def index(%{orders: orders}) do
    %{data: for(order <- orders, do: limited_data(order))}
  end

  @doc """
  Renders a single order.
  """
  def show(%{order: order}) do
    %{data: data(order)}
  end

  def show(%{order: order, related_users: related_users}) do
    %{data: data(order, related_users)}
  end

  defp limited_data(order = %Order{}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status
    }
  end

  defp data(order = %Order{}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status,
      seller_id: order.seller_id,
      buyer_user: order.buyer_user_id,
      delivery_address: data(order.delivery_address),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark
    }
  end

  defp data(order = %Order{}, _related_users = {seller_user = %User{}, buyer_user = %User{}, deliverer_user = %User{}}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status,
      seller_user: data(seller_user),
      buyer_user: data(buyer_user),
      deliverer_user: data(deliverer_user),
      delivery_address: data(order.delivery_address),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark
    }
  end

  defp data(order = %Order{}, _related_users = {seller_user = %User{}, buyer_user = %User{}, nil}) do
    %{
      id: order.id,
      date: order.inserted_at,
      status: order.status,
      seller_user: data(seller_user),
      buyer_user: data(buyer_user),
      deliverer_user: nil,
      delivery_address: data(order.delivery_address),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark
    }
  end

  defp data(user = %User{}) do
    %{
      id: user.id,
      address: data(user.address),
      phone_number: user.phone_number,
      email_id: user.email_id,
      first_name: user.first_name,
      gender: user.gender,
      last_name: user.last_name,
      profile_image: user.profile_image
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

  defp data(address = %Address{}) do
    %{
      door_number: address.door_number,
      street: address.street,
      city: address.city,
      country: address.country,
      postal_code: address.postal_code
    }
  end
end
