defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  """
  use FoodFromHomeWeb, :controller
  plug Ueberauth

  def request(conn, _params) do
    Ueberauth.Strategy.Auth0.OAuth.authorization_url(conn)
  end

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect fails
    conn
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect auth
    # Handle successful authentication, e.g., create user session or generate JWT
    conn
  end
end
