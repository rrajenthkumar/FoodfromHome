defmodule FoodFromHome.Users.Services.UpdateUserWithGeoposition do
  @moduledoc false
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.Utils

  def call(user = %User{}, attrs = %{address: _address}) do
    attrs = Utils.add_geoposition_to_attrs(attrs)

    Users.update_user(user, attrs)
  end
end
