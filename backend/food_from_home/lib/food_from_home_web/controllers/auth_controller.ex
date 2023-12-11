defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  """
  use FoodFromHomeWeb, :controller
  plug Ueberauth

  def request(_conn, _params) do
    # Ueberauth.Strategy.Auth0.OAuth.authorization_url(conn)
  end

  def callback(conn = %{assigns: %{ueberauth_failure: _fails}}, _params) do
    conn
  end

  def callback(conn = %{assigns: %{ueberauth_auth: _auth}}, _params) do
    # Handle successful authentication, e.g., create user session or generate JWT
    conn
  end
end
