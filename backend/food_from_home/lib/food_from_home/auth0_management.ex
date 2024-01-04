defmodule FoodFromHome.Auth0Management do
  @moduledoc """
  Module to manage Auth0 users using Auth0 Management API
  """
  alias Auth0.Entity.User
  alias Auth0.Entity.Users
  alias Auth0.Management
  alias Auth0.Management.UsersByEmail

  @auth0_management_api_config %Auth0.Config{
    domain: Application.compile_env(:food_from_home, Auth0ManagementAPI)[:domain],
    client_id: Application.compile_env(:food_from_home, Auth0ManagementAPI)[:client_id],
    client_secret: Application.compile_env(:food_from_home, Auth0ManagementAPI)[:client_secret]
  }

  def create_auth0_user(params = %{email: _email, password: _password}) do
    params = Map.put(params, :connection, "Username-Password-Authentication")

    result =
      Management.Users.create(
        params,
        @auth0_management_api_config
      )

    case result do
      {:ok, %User{} = user, _response_body} ->
        {:ok, user}

      error ->
        error
    end
  end

  def update_auth0_user(email, params \\ %{}) when is_binary(email) do
    {:ok, %User{user_id: auth0_user_id}} = get_auth0_user_from_email(email)

    params = Map.put(params, :connection, "Username-Password-Authentication")

    result =
      Management.Users.update(
        auth0_user_id,
        params,
        @auth0_management_api_config
      )

    case result do
      {:ok, %User{} = user, _response_body} ->
        {:ok, user}

      error ->
        error
    end
  end

  def delete_auth0_user(email) when is_binary(email) do
    {:ok, %User{user_id: auth0_user_id} = to_be_deleted_user} = get_auth0_user_from_email(email)

    result =
      Management.Users.delete(
        auth0_user_id,
        @auth0_management_api_config
      )

    case result do
      {:ok, _status, _response_body} ->
        {:ok, to_be_deleted_user}

      error ->
        error
    end
  end

  defp get_auth0_user_from_email(email) when is_binary(email) do
    result = UsersByEmail.list(_params = %{"email" => email}, @auth0_management_api_config)

    case result do
      {:ok, %Users{users: []}, _response_body} ->
        {:error, "No auth0 account found"}

      {:ok, %Users{users: [user]}, _response_body} ->
        {:ok, user}

      error ->
        error
    end
  end
end
