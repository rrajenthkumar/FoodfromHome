defmodule FoodFromHome.Auth0Management.Utils do
  @moduledoc """
  Utility functions related to Auth0 management
  """

  def validate_email(email) when is_binary(email) do
    case Regex.match?(~r/@/, email) do
      true ->
        {:ok, email}

      :error ->
        {:error, "Invalid email"}
    end
  end

  def validate_password(password) when is_binary(password) do
    case Base.decode64(password, ignore: :whitespace) do
      {:ok, _decoded_password} ->
        {:ok, password}

      :error ->
        {:error, "Invalid password"}
    end
  end
end
