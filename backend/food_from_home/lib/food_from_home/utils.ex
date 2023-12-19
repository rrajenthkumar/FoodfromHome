defmodule FoodFromHome.Utils do
  @moduledoc """
  Module for FoodFromHome utility functions.
  """
  import Ecto.Changeset

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

  def validate_unallowed_fields(changeset = %Ecto.Changeset{}, attrs = %{}, allowed_keys)
      when is_list(allowed_keys) do
    attrs_keys = Map.keys(attrs)
    unallowed_keys = attrs_keys -- allowed_keys

    case Enum.empty?(unallowed_keys) do
      true -> changeset
      false -> add_error(changeset, :base, "Unallowed fields in request: #{unallowed_keys}")
    end
  end
end
