defmodule FoodFromHome.Users.Services.CreateUserWithGeoposition do
  @moduledoc false
  alias FoodFromHome.Users
  alias FoodFromHome.Users.Utils

  def call(attrs = %{address: _address}) do
    attrs
    |> Utils.add_geoposition_to_attrs()
    |> Users.create_user()
  end
end
