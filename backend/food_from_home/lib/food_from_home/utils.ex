defmodule FoodFromHome.Utils do
  @moduledoc """
  Module for FoodFromHome utility functions.
  """
  import Ecto.Changeset

  def convert_string_keys_to_atoms(data) when is_map(data) do
    Enum.map(data, fn
      {key, value} when is_binary(key) ->
        {String.to_atom(key), convert_string_keys_to_atoms(value)}

      {key, value} when is_atom(key) ->
        {key, convert_string_keys_to_atoms(value)}
    end)
    |> Enum.into(%{})
  end

  def convert_string_keys_to_atoms(data) do
    data
  end

  def convert_map_to_keyword_list(data) when is_map(data) do
    Enum.map(data, fn
      {key, value} when is_binary(key) -> {String.to_atom(key), value}
      pair_with_atom_key -> pair_with_atom_key
    end)
  end

  def validate_unallowed_fields(changeset = %Ecto.Changeset{}, attrs = %{}, allowed_keys)
      when is_list(allowed_keys) do
    attrs_keys = Map.keys(attrs)
    unallowed_keys = attrs_keys -- allowed_keys

    case Enum.empty?(unallowed_keys) do
      true ->
        changeset

      false ->
        unallowed_keys = Enum.map(unallowed_keys, fn key -> Atom.to_string(key) end)
        add_error(changeset, :base, "Unallowed fields in request: #{unallowed_keys}")
    end
  end

  def convert_string_values_to_atoms(attrs, keys_of_atom_type_fields)
      when is_map(attrs) and is_list(keys_of_atom_type_fields) do
    converted_fields_map =
      Enum.reduce(keys_of_atom_type_fields, %{}, fn key_of_atom_type_field, acc ->
        converted_field =
          attrs
          |> Map.get(key_of_atom_type_field)
          |> String.to_existing_atom()

        Map.put_new(acc, key_of_atom_type_field, converted_field)
      end)

    Map.merge(attrs, converted_fields_map)
  end
end
