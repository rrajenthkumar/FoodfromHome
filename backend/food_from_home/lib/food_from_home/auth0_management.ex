defmodule FoodFromHome.Auth0Management do
  @moduledoc """
  Module to create, update and delete Auth0 users using Auth0 Management API
  """
  @auth0_domain Application.compile_env(:food_from_home, FoodFromHome.Auth0Management)[:domain]
  @management_api_token Application.compile_env(:food_from_home, FoodFromHome.Auth0Management)[:management_api_token]

  def create_user(email, password) when is_binary(email) and is_binary(password) do
    user_data = %{
      email: email,
      password: password,
      connection: "Username-Password-Authentication"
    }

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{@management_api_token}"}
    ]

    auth0_management_api_url = "https://#{@auth0_domain}/api/v2/users"

    result =
      HTTPoison.post(
        auth0_management_api_url,
        Jason.encode!(%{user: user_data}),
        headers,
        [:json]
      )

    case result do
      {:ok, %{status_code: 201, body: body}} ->
        {:ok, body}

      {:ok, %{status_code: code, body: body}} ->
        {:error, "Auth0 user creation failed with status code #{code}: #{body}"}

      {:error, reason} ->
        {:error, "Failed to communicate with Auth0 Management API: #{reason}"}
    end
  end
end
