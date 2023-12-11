defmodule FoodFromHome.Users.Utils do
  @moduledoc false
  alias FoodFromHome.Geocoding
  alias FoodFromHome.Users.User.Address

  def add_geoposition_to_attrs(attrs = %{address: address}) do
    geoposition =
      Address
      |> struct!(address)
      |> Geocoding.get_position()

    Map.put(attrs, :geoposition, geoposition)
  end
end
