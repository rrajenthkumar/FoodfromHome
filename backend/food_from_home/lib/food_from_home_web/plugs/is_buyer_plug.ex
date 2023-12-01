defmodule FoodFromHomeWeb.IsBuyerPlug do
  @moduledoc """
  This plug checks if the current user is of type :buyer.
  """
  @behaviour Plug

  import Plug.Conn

  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users.User
  alias FoodFromHomeWeb.ErrorHandler

  @impl Plug
  def init(default), do: default

  @impl Plug
  def call(conn = %{assigns: %{current_user: %User{user_type: user_type}}}, _default) do
    case user_type do
      :buyer ->
        conn
      _ ->
        ErrorHandler.handle_error(conn, "403", "Route accessible only to users of type :buyer")
    end
  end
end
