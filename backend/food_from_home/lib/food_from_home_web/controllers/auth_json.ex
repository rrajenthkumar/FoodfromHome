defmodule FoodFromHomeWeb.AuthJSON do
  @doc """
  Renders a jwt.
  """
  def show(%{jwt: jwt}) do
    %{data: %{jwt: jwt}}
  end
end
