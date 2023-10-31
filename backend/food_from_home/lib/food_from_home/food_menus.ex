defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context.
  """

  import Ecto.Query, warn: false
  alias FoodFromHome.Repo

  alias FoodFromHome.FoodMenus.FoodMenu

  @doc """
  Returns the list of food_menus.

  ## Examples

      iex> list_food_menus()
      [%FoodMenu{}, ...]

  """
  def list_food_menus do
    Repo.all(FoodMenu)
  end

  @doc """
  Gets a single food_menu.

  Raises `Ecto.NoResultsError` if the Food menu does not exist.

  ## Examples

      iex> get_food_menu!(123)
      %FoodMenu{}

      iex> get_food_menu!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_menu!(id), do: Repo.get!(FoodMenu, id)

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

      iex> update_food_menu(food_menu, %{field: new_value})
      {:ok, %FoodMenu{}}

      iex> update_food_menu(food_menu, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_menu(%FoodMenu{} = food_menu, attrs) do
    food_menu
    |> FoodMenu.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_menu.

  ## Examples

      iex> delete_food_menu(food_menu)
      {:ok, %FoodMenu{}}

      iex> delete_food_menu(food_menu)
      {:error, %Ecto.Changeset{}}

  """
  def delete_food_menu(%FoodMenu{} = food_menu) do
    Repo.delete(food_menu)
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
