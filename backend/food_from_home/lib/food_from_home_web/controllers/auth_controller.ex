defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  """
  use FoodFromHomeWeb, :controller
  plug Ueberauth

  alias FoodFromHome.Guardian
  alias FoodFromHome.Users

  def callback(conn = %{assigns: %{ueberauth_auth: %{info: %{email: email}}}}, _params) do
    {:ok, jwt, _full_claims} =
      email
      |> Users.get_user_from_email!()
      |> Guardian.encode_and_sign()

    render(conn, json: %{jwt: jwt})
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: "/")
  end
end
