defmodule FoodFromHomeWeb.ErrorHandler do
  @moduledoc """
  Handles errors in plugs and controllers
  """
  use FoodFromHomeWeb, :controller

  @doc """
  Puts error status in connection, renders ErrorJSON with given error status and error detail and halts the connection.
  """
  def handle_error(conn, error_status, error_detail) do
    conn
    |> put_status(error_status)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"#{error_status}", detail: error_detail)
    |> Plug.Conn.halt()
  end
end
