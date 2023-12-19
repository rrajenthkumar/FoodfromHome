defmodule FoodFromHomeWeb.Utils do
  @moduledoc """
  Module for FoodFromHomeWeb related utility functions.
  """
  alias FoodFromHomeWeb.ErrorHandler

  def unallowed_attributes_check(conn, attrs = %{}, allowed_attrs_keys)
      when is_list(allowed_attrs_keys) do
    attrs_keys = Map.keys(attrs)
    unallowed_attrs_keys = attrs_keys -- allowed_attrs_keys

    case Enum.empty?(unallowed_attrs_keys) do
      true ->
        {:ok, attrs}

      false ->
        ErrorHandler.handle_error(
          conn,
          :unprocessable_entity,
          "Unallowed attrs #{unallowed_attrs_keys} in request"
        )
    end
  end
end
