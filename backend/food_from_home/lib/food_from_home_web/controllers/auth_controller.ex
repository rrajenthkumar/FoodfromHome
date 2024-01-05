defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  """
  use FoodFromHomeWeb, :controller
  plug Ueberauth

  alias FoodFromHome.Guardian
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHomeWeb.ErrorHandler

  def callback(conn = %{assigns: %{ueberauth_auth: %{info: %{email: email}}}}, _params) do
    case Users.get_user_from_email(email) do
      %User{} = user ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

        render(conn, :show, token: jwt)

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "User resource corresponding to auth0 user not found"
        )
    end
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
