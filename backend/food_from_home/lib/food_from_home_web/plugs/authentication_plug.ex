defmodule FoodFromHomeWeb.AuthenticationPlug do
  @moduledoc """
  This plug checks if there is an authenticated user.
  """
  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHomeWeb.ErrorHandler
  alias Guardian.Plug.VerifyHeader

  def init(_opts), do: []

  def call(conn, _opts) do
    case VerifyHeader.call(conn, jwt_module: FoodFromHome.Guardian) do
      {:ok, conn} ->
        conn

      {:error, _reason, conn} ->
        ErrorHandler.handle_error(
          conn,
          :unauthorized,
          "No authenticated user"
        )
    end
  end
end
