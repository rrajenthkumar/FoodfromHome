defmodule FoodFromHomeWeb.CurrentUserPlug do
  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users.User
  alias FoodFromHomeWeb.ErrorHandler

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user ->
        Plug.Conn.assign(conn, :current_user, user)

      nil ->
        ErrorHandler.handle_error(
          conn,
          :unauthorized,
          "No current resource found"
        )
    end
  end
end
