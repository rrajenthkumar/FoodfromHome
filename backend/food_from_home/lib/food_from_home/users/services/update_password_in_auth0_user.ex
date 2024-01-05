defmodule FoodFromHome.Users.Services.UpdatePasswordInAuth0User do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users.User

  def call(user = %User{email_id: email}, attrs = %{password: _encoded_password}) do
    case Auth0Management.update_auth0_user(email, attrs) do
      {:ok, _auth0_user} ->
        {:ok, user}

      {:error, reason} ->
        {:error, 500, "Unable to update password in auth0 user. Reason: #{reason}"}

      {:error, status, reason} ->
        {:error, status, "Unable to update password in auth0 user. Reason: #{reason}"}
    end
  end
end
