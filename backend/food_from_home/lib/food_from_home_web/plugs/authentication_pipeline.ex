defmodule FoodFromHomeWeb.AuthenticationPipeline do
  @moduledoc """
  This pipeline looks for a token, loads a resource if found and assigns it to the connection
  """
  use Guardian.Plug.Pipeline,
    otp_app: :food_from_home,
    error_handler: FoodFromHomeWeb.GuardianErrorHandler,
    module: FoodFromHome.Guardian

  # Looks for and validates a token found in the session
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # Looks for and validates a token found in the Authorization header
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Loads the resource associated with a previously validated token
  plug Guardian.Plug.LoadResource, allow_blank: true
  # Ensures that a valid token was provided and has been verified on the request
  plug Guardian.Plug.EnsureAuthenticated
  # Assigns current user to connection
  plug FoodFromHomeWeb.CurrentUserPlug
end
