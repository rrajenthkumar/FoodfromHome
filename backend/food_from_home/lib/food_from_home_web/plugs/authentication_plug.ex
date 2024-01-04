defmodule FoodFromHomeWeb.AuthenticationPlug do
  @moduledoc """
  This plug extracts user from the JWT and assigns it to conn.
  """
  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHomeWeb.ErrorHandler
  alias Guardian.Plug.VerifyHeader

  def init(_opts), do: []

  def call(conn, _opts) do
    case VerifyHeader.call(conn, jwt_module: FoodFromHome.Guardian) do
      {:ok, user} ->
        assign(conn, :current_user, user)

      {:error, reason} ->
        ErrorHandler.handle_error(
          conn,
          :unauthorized,
          reason
        )
    end
  end
end
