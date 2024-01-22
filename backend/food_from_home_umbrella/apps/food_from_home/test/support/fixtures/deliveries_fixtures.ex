defmodule FoodFromHome.DeliveriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Deliveries` context.
  """

  @doc """
  Generate a delivery.
  """
  def delivery_fixture(attrs \\ %{}) do
    {:ok, delivery} =
      attrs
      |> Enum.into(%{
        delivered_at: ~U[2023-11-02 08:23:00Z],
        distance_travelled_in_kms: "120.5",
        picked_up_at: ~U[2023-11-02 08:23:00Z],
        current_geoposition: %Geo.Point{coordinates: {75, -35}, srid: 4578}
      })
      |> FoodFromHome.Deliveries.create_delivery()

    delivery
  end
end
