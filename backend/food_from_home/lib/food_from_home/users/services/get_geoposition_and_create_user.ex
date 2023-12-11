defmodule FoodFromHome.Users.Services.GetGeopositionAndCreateUser do
  @moduledoc false
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Utils

  def call(attrs = %{address: _address}) do
    attrs
    |> Utils.add_geoposition_to_attrs()
    |> UserRepo.create_user()
  end
end
