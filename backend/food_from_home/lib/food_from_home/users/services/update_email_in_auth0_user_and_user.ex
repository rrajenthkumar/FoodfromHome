defmodule FoodFromHome.Users.Services.UpdateEmailInAuth0UserAndUser do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def call(user = %User{email: email}, param = %{email: _new_email}) do
    case Auth0Management.update_auth0_user(email, param) do
      {:ok, _auth0_user} ->
        Users.update_user(user, param)

      {:error, reason} ->
        {:error, 500,
         "Unable to update email id in auth0 user and user resource. Reason: #{reason}"}

      {:error, status, reason} ->
        {:error, status,
         "Unable to update email id in auth0 user and user resource. Reason: #{reason}"}
    end
  end
end
