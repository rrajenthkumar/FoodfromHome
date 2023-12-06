defmodule FoodFromHome.Deliveries.Services.AddPickupTime do
  @moduledoc """
  Adds the delivery picked_up_at time for a delivery
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery

  def call(delivery = %Delivery{picked_up_at: nil}) do
    picked_up_at = DateTime.utc_now()

    Deliveries.update(delivery, %{picked_up_at: picked_up_at})
  end

  def call(%Delivery{}) do
    {:error, 403, "Delivery picked_up_at time cannot be added as it already exists"}
  end
end
