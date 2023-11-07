defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  All CRUD operations related to food_menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.FoodMenus.FoodMenu

  @doc """
  Gets a single food_menu.

  Raises `Ecto.NoResultsError` if the Food menu does not exist.

  ## Examples

      iex> get_food_menu!(123)
      %FoodMenu{}

      iex> get_food_menu!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_menu!(menu_id), do: Repo.get!(FoodMenu, menu_id)

  @doc """
  Creates a food_menu.

  ## Examples

      iex> create_food_menu(%{field: value})
      {:ok, %FoodMenu{}}

      iex> create_food_menu(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_food_menu(attrs \\ %{}) do
    %FoodMenu{}
    |> FoodMenu.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a food_menu.

  ## Examples

      iex> update_food_menu(menu_id, %{field: new_value})
      {:ok, %FoodMenu{}}

      iex> update_food_menu(menu_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_menu(menu_id, attrs) do
    menu_id
    |> get_food_menu!()
    |> change_food_menu(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_menu.

  ## Examples

      iex> delete_food_menu(menu_id)
      {:ok, %FoodMenu{}}

      iex> delete_food_menu(menu_id)
      {:error, %Ecto.Changeset{}}

  """
  def delete_food_menu(menu_id) do
    menu_id
    |> get_food_menu!()
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes.

  ## Examples

      iex> change_food_menu(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def change_food_menu(%FoodMenu{} = food_menu, attrs \\ %{}) do
    FoodMenu.changeset(food_menu, attrs)
  end
end
