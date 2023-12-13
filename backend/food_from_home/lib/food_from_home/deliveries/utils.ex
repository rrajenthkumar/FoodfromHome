defmodule FoodFromHome.Deliveries.Utils do
  @moduledoc """
  Utility functions related to Delivery context
  """
  alias FoodFromHome.Deliveries.Delivery

  def is_delivery_older_than_a_month?(%Delivery{delivered_at: delivered_at}) do
    {:ok, delivered_at} = DateTime.from_naive(delivered_at, "Etc/UTC")
    now = DateTime.utc_now()

    # To check if the difference is not more than 31 days
    DateTime.diff(delivered_at, now) >= 31 * 24 * 60 * 60
  end
end
