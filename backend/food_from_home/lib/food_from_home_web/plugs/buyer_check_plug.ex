defmodule FoodFromHomeWeb.BuyerCheckPlug do
  @moduledoc """
  This plug checks if the current user is of type :buyer.
  """
  @behaviour Plug

  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users.User

  @impl Plug
  def init(default), do: default

  @impl Plug
  def call(conn = %{assigns: %{current_user: %User{user_type: user_type}}}, _default) do
    case user_type do
      :buyer ->
        conn
      _ ->
        conn
        |> put_status(:forbidden)
        |> put_view(html: FoodFromHomeWeb.ErrorHTML, json: FoodFromHomeWeb.ErrorJSON)
        |> render(:"403")
        |> Plug.Conn.halt()
    end
  end

  @doc """
  When there is no current user
  """
  def call(conn, _default) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: FoodFromHomeWeb.ErrorHTML, json: FoodFromHomeWeb.ErrorJSON)
    |> render(:"401")
    |> Plug.Conn.halt()
  end
end
