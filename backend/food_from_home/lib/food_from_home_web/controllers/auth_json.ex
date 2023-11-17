defmodule FoodFromHomeWeb.AuthJson do
  alias FoodFromHome.Auth.TokenResult

  @doc """
  Renders token result.
  """
  def render("show.json", %{token_result: %TokenResult{} = token_result}) do
    %{
      accessToken: token_result.access_token,
      expiresIn: token_result.expires_in
    }
  end
end
