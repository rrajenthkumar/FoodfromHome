defmodule FoodFromHomeWeb.ErrorHandler do
  @moduledoc """
  Handles errors in plugs
  """
  use FoodFromHomeWeb, :controller

  @doc """
  Puts error status in connection and renders ErrorJSON with given error status and error message.
  Also halts the connection.
  """
  def handle_error(conn, error_status, error_message) do
    conn
    |> put_status(error_status)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"#{error_status}", message: error_message)
    |> Plug.Conn.halt()
  end
end
