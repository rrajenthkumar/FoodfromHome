defmodule FoodFromHome.Orders.Services.UpdateDeliveryAddress do
  @moduledoc """
  Just before checkout a buyer user has the possibility to update the delivery address which is his address by default.
  """
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order

  def call(order = %Order{status: :open}, delivery_address) when is_map(delivery_address) do
    Orders.update_order(order, %{delivery_address: delivery_address})
  end

  def call(%Order{status: another_status}, delivery_address) when is_map(delivery_address) do
    {:error, 403,
     "Order in #{another_status} status. Address can be changed for only an order of :open status"}
  end
end
