defmodule FoodFromHome.Utils do
  @moduledoc """
  Module for all utility functions.
  """
  def convert_map_string_keys_to_atoms(data) when is_map(data) do
    Enum.map(data, fn
      {key, value} when is_binary(key) ->
        {String.to_existing_atom(key), convert_map_string_keys_to_atoms(value)}

      {key, value} when is_atom(key) ->
        {key, convert_map_string_keys_to_atoms(value)}
    end)
    |> Enum.into(%{})
  end

  def convert_map_string_keys_to_atoms(data) do
    data
  end

  def convert_map_to_keyword_list(data) when is_map(data) do
    Enum.map(data, fn
      {key, value} when is_binary(key) -> {String.to_existing_atom(key), value}
      pair_with_atom_key -> pair_with_atom_key
    end)
  end
end
