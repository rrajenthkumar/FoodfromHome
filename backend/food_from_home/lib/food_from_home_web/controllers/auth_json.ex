defmodule FoodFromHomeWeb.AuthJSON do
  @doc """
  Renders a jwt.
  """
  def show(data = %{}) do
    %{token: data.token}
  end
end
