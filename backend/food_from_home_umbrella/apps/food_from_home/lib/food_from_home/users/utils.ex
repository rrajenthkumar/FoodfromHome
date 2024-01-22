defmodule FoodFromHome.Users.Utils do
  @moduledoc """
  Utility functions related to User context
  """
  alias FoodFromHome.Geocoding
  alias FoodFromHome.Users.User.Address

  def add_geoposition_to_attrs(attrs = %{address: address}) do
    geoposition_result =
      Address
      |> struct!(address)
      |> Geocoding.get_position()

    with {:ok, geoposition} <- geoposition_result do
      Map.put(attrs, :geoposition, geoposition)
    end
  end
end
