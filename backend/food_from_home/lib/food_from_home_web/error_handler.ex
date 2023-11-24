defmodule FoodFromHomeWeb.ErrorHandler do
  @moduledoc """
  Handles errors in plugs
  """
  use FoodFromHomeWeb, :controller

  def handle_error(conn, _error_status = "401") do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"401")
    |> Plug.Conn.halt()
  end

  def handle_error(conn, _error_status = "403") do
    conn
    |> put_status(:forbidden)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"403")
    |> Plug.Conn.halt()
  end
end
