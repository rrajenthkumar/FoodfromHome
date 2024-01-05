defmodule FoodFromHome.Users.Services.UpdateEmailInAuth0UserAndUser do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def call(user = %User{email_id: email}, attrs = %{email_id: new_email}) do
    case Auth0Management.update_auth0_user(email, %{email: new_email}) do
      {:ok, _auth0_user} ->
        Users.update_user(user, attrs)

      {:error, reason} ->
        {:error, 500,
         "Unable to update email id in auth0 user and user resource. Reason: #{reason}"}

      {:error, status, reason} ->
        {:error, status,
         "Unable to update email id in auth0 user and user resource. Reason: #{reason}"}
    end
  end
end
