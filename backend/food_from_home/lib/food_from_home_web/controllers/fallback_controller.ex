defmodule FoodFromHomeWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FoodFromHomeWeb, :controller

  def call(conn, {:error, status, error_detail}) do
    conn
    |> put_status(status)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"#{status}", detail: error_detail)
  end

  def call(conn, Ecto.NoResultsError) do
    conn
    |> put_status(:not_found)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"404", detail: "Ecto.NoResultsError")
  end

  def call(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"422", detail: "Ecto.Changeset error")
  end
end
