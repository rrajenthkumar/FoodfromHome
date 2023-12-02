defmodule FoodFromHome.Orders.Services.SetReadyForPickupStatus do
  @moduledoc """
  A seller user can change the status of a confirmed order to :ready_for_pickup once the food is ready.
  """
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order

  def call(order = %Order{status: :confirmed}) do
    Orders.update(order, %{status: :ready_for_pickup})
  end

  def call(order = %Order{status: another_status}) do
    {:error, 403, "Order in #{another_status} status. Only an order of :confirmed status can be marked as ready for pickup"}
  end
end
