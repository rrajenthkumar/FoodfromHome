defmodule FoodFromHomeWeb.IsSellerPlug do
  @moduledoc """
  This plug checks if the current user is of type :seller.
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
      :seller ->
        conn
      _ ->
        ErrorHandler.handle_error(conn, "403", "The current user is not of type :seller")
    end
  end
end