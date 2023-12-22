defmodule FoodFromHome.Deliveries.Services.AddDeliveryTime do
  @moduledoc """
  Adds the delivered_at time for a delivery
  """
  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery

  def call(delivery = %Delivery{delivered_at: nil}) do
    delivered_at = DateTime.utc_now()

    Deliveries.update_delivery(delivery, %{delivered_at: delivered_at})
  end

  def call(%Delivery{}) do
    {:error, 403, "Delivery time cannot be added as it exists already"}
  end
end
