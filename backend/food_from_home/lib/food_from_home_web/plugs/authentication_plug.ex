defmodule FoodFromHomeWeb.AuthenticationPlug do
  @moduledoc """
  This plug checks if there is an authenticated user.
  """
  @behaviour Plug

  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users.User
  alias FoodFromHomeWeb.ErrorHandler

  @impl Plug
  def init(default), do: default

  # Has to be updated to properly check if there is an authenticated user!!!
  @impl Plug
  def call(conn = %{assigns: %{current_user: %User{}}}, _default) do
    conn
  end

  def call(conn = %{assigns: %{current_user: nil}}, _default) do
    ErrorHandler.handle_error(conn, "401", "No current user found")
  end

  def call(conn, _default) do
    ErrorHandler.handle_error(conn, "401", "No current user found")
  end
end
