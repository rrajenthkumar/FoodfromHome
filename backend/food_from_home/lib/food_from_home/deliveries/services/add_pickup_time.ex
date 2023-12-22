defmodule FoodFromHome.Deliveries.Services.AddPickupTime do
  @moduledoc """
  Adds the picked_up_at time for a delivery
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery

  def call(delivery = %Delivery{picked_up_at: nil}) do
    picked_up_at = DateTime.utc_now()

    Deliveries.update_delivery(delivery, %{picked_up_at: picked_up_at})
  end

  def call(%Delivery{}) do
    {:error, 403, "Delivery pick up time cannot be added as it exists already"}
  end
end
