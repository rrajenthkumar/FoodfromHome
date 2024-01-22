defmodule FoodFromHome.Users.Services.GetUpdatedGeopositionAndUpdateUser do
  @moduledoc false
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Utils

  def call(user = %User{}, attrs = %{address: _address}) do
    attrs = Utils.add_geoposition_to_attrs(attrs)

    UserRepo.update_user(user, attrs)
  end
end
