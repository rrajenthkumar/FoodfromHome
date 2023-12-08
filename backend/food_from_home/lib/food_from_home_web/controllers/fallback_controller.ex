defmodule FoodFromHomeWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FoodFromHomeWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"422", detail: "Ecto.Changeset error")
  end

  def call(conn, {:error, error_status, error_detail}) do
    error_status_code = Plug.Conn.Status.code(error_status)

    conn
    |> put_status(error_status)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"#{error_status_code}", detail: error_detail)
  end
end
