defmodule FoodFromHome.Users.Services.CreateAuth0UserAndGetGeopositionAndCreateUserResource do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Utils

  def call(attrs = %{email: email, password: password, address: _address}) do
    case Auth0Management.create_auth0_user(%{email: email, password: password}) do
      {:ok, _auth0_user} ->
        attrs
        |> Map.drop(:password)
        |> Utils.add_geoposition_to_attrs()
        |> UserRepo.create_user()

      {:error, reason} ->
        {:error, 500, "Unable to create the auth0 user and the user resource. Reason: #{reason}"}

      {:error, _status, reason} ->
        {:error, 500, "Unable to create the auth0 user and the user resource. Reason: #{reason}"}
    end
  end
end
