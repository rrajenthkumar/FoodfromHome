defmodule FoodFromHome.Orders.Services.SetReservedForPickupStatusAndInitiateDelivery do
  @moduledoc """
  Used by a deliverer to reserve an order for pickup.
  Simultaneously a new delivery record is created with seller's location as current location.
  """

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  def call(
        order = %Order{status: :ready_for_pickup},
        deliverer_user = %User{user_type: :deliverer}
      ) do
    case Orders.update_order(order, %{status: :reserved_for_pickup}) do
      {:ok, %Order{} = order} ->
        initiate_delivery(order, deliverer_user)

      error ->
        error
    end
  end

  def call(
        %Order{status: another_status},
        _deliverer_user
      ) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :ready_for_pickup status can be reserved for pickup."}
  end

  defp initiate_delivery(
         order = %Order{status: :reserved_for_pickup},
         deliverer_user = %User{user_type: :deliverer}
       ) do
    case Deliveries.initiate_delivery(order, deliverer_user) do
      {:ok, %Delivery{}} ->
        {:ok, order}

      {:error, delivery_initiation_error_reason} ->
        # Rollingback status change
        case Orders.update_order(order, %{status: :ready_for_pickup}) do
          {:ok, %Order{}} ->
            {:error, 500,
             "The status update operation has been rolled back as creation of an associated delivery failed due to the following reason: #{delivery_initiation_error_reason}"}

          {:error, reason} ->
            {:error, 500,
             "Associated delivery creation failed due to the following reason: #{delivery_initiation_error_reason} and the eventual order status update rollback too failed due to the following reason: #{reason}"}
        end
    end
  end
end
