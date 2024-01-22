defmodule FoodFromHome.Users.Services.DeleteAuth0UserAndSoftDeleteUser do
  @moduledoc false
  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.User

  def call(user = %User{email: email}) do
    case Auth0Management.delete_auth0_user(email) do
      {:ok, _auth0_user} ->
        UserRepo.soft_delete_user(user)

      {:error, reason} ->
        {:error, 500, "Unable to delete auth0 user and user resource. Reason: #{reason}"}

      {:error, status, reason} ->
        {:error, status, "Unable to delete auth0 user and user resource. Reason: #{reason}"}
    end
  end
end
