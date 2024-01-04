defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  """
  use FoodFromHomeWeb, :controller
  plug Ueberauth

  alias FoodFromHome.Guardian
  alias FoodFromHome.Users
  alias FoodFromHomeWeb.ErrorHandler

  def callback(conn = %{assigns: %{ueberauth_auth: %{info: %{email: email}}}}, _params) do
    {:ok, jwt, _full_claims} =
      email
      |> Users.get_user_from_email!()
      |> Guardian.encode_and_sign()

    render(conn, :show, token: jwt)
  end

  def callback(
        conn = %{assigns: %{ueberauth_failure: %Ueberauth.Failure{errors: errors}}},
        _params
      ) do
    errors =
      errors
      |> Enum.map(fn %Ueberauth.Failure.Error{message: message} -> message end)
      |> Enum.join(",")

    ErrorHandler.handle_error(
      conn,
      :internal_server_error,
      "Ueberauth failure. Reasons: #{errors}."
    )
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/auth/auth0")
  end
end
