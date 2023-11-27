defmodule FoodFromHomeWeb.HasCurrentUserPlug do
  @moduledoc """
  This plug checks if the connection has a current_user assign.
  Later this might be replaced with a IsAuthenticated plug as a current user will always be fetched and assigned during authentication.
  """
  @behaviour Plug

  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users.User
  alias FoodFromHomeWeb.ErrorHandler

  @impl Plug
  def init(default), do: default

  @impl Plug
  def call(conn = %{assigns: %{current_user: %User{}}}, _default) do
    conn
  end

  def call(conn = %{assigns: %{current_user: nil}}, _default) do
    ErrorHandler.handle_error(conn, "401", "There is no current user")
  end

  def call(conn, _default) do
    ErrorHandler.handle_error(conn, "401", "There is no current user")
  end
end
