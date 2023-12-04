defmodule FoodFromHome.Orders.Services.SetReservedForPickupStatusAndCreateDelivery do
  @moduledoc """
  Used by a deliverer to reserve an order for pickup.
  Simultaneously a new delivery record is created with seller's location as current location.
  """

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  def call(order = %Order{status: :ready_for_pickup}, deliverer_user = %User{user_type: :deliverer}) do
    with {:ok, %Order{}} = result <- Orders.update(order, %{status: :reserved_for_pickup}) do
      case Deliveries.initiate_delivery(order, deliverer_user) do
        {:ok, %Delivery{}} -> result
        {:error, reason} ->
          # Rollingback status change
          with {:ok, %Order{}} <- Orders.update(order, %{status: :ready_for_pickup}) do
            {:error, 500, "The status update operation has been rolled back as creation of an associated delivery failed due to the following reason: #{reason}. "}
          end
      end
    end
  end

  def call(order = %Order{status: another_status}, _deliverer_user = %User{user_type: :deliverer}) do
    {:error, 403, "Order in #{another_status} status. Only an order of :ready_for_pickup status can be reserved for pickup"}
  end
end
