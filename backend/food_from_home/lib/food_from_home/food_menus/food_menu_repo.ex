defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  All CRUD operations related to food_menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Sellers

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
  Returns the list of active food_menus from a seller.

  ## Examples

    iex> list_active_food_menus_from_seller(12345)
    [%FoodMenu{}, ...]

  """
  def list_active_food_menus_from_seller(seller_id) do
    query =
      from(food_menu in FoodMenu,
        where: food_menu.seller_id == ^seller_id and food_menu.valid_until >= ^DateTime.utc_now(),
        select: {food_menu.name, food_menu.description, food_menu.menu_illustration, food_menu.ingredients, food_menu.allergens, food_menu.price, food_menu.rebate}
      )

    Repo.all(query)
  end

  @doc """
  Creates a food_menu.

  ## Examples

      iex> create_food_menu(%{field: value}, 12345)
      {:ok, %FoodMenu{}}

      iex> create_food_menu(%{field: bad_value}, 12345)
      {:error, %Ecto.Changeset{}}

  """
  def create_food_menu(attrs \\ %{}, seller_id) do
    seller_id
    |> Sellers.get_seller!()
    |> Ecto.build_assoc(:food_menus, attrs)
    |> change_food_menu(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a food_menu.

  ## Examples

      iex> update_food_menu(12345, %{field: new_value})
      {:ok, %FoodMenu{}}

      iex> update_food_menu(12345, %{field: bad_value})
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

      iex> delete_food_menu(12345)
      {:ok, %FoodMenu{}}

      iex> delete_food_menu(12345)
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
