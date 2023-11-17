defmodule FoodFromHomeWeb.AuthController do
  @moduledoc """
  This controller allows retrieving an access token from auth0 and returning it to the user
  providing username / password based login capability
  """
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Auth
  alias FoodFromHome.Auth.{Credentials, TokenResult}

  require Logger

  action_fallback FoodFromHomeWeb.FallbackController

  def login(conn, credentials) do
    _ = Logger.debug(fn -> "Login attempt with user: #{credentials.username}" end)

    with {:ok, credentials} <- Credentials.validate(credentials),
         {:ok, %TokenResult{} = token_result} <- Auth.sign_in(credentials) do
      conn
      |> put_status(:ok)
      |> render(:show, token_result: token_result)
    end
  end
end
