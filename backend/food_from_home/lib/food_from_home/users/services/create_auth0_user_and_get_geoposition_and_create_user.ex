defmodule FoodFromHome.Users.Services.CreateAuth0UserAndGetGeopositionAndCreateUser do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Utils

  def call(attrs = %{email: email, password: encoded_password}) do
    case Auth0Management.create_auth0_user(%{email: email, password: encoded_password}) do
      {:ok, _auth0_user} ->
        attrs
        |> Map.drop([:password])
        |> Utils.add_geoposition_to_attrs()
        |> UserRepo.create_user()

      {:error, reason} ->
        {:error, 500, "Unable to create auth0 user and user resource. Reason: #{reason}"}

      {:error, status, reason} ->
        {:error, status, "Unable to create auth0 user and user resource. Reason: #{reason}"}
    end
  end
end
