defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  All CRUD operations related to food menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers

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
    |> change_food_menu()
    |> Repo.insert()
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
  def get_food_menu!(menu_id), do: Repo.get!(FoodMenu, menu_id)

  @doc """
  Updates a food_menu.

  ## Examples

      iex> update_food_menu(%{field: new_value}, 12345)
      {:ok, %FoodMenu{}}

      iex> update_food_menu(%{field: new_value}, 12345)
      {:error, %Ecto.Changeset{}}

  """
  def update_food_menu(attrs = %{}, menu_id) do
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
  Returns a list of food_menus after applying given filters.
  When 'active' filter is set to 'true' only the food menus whose validity haven't expired will be listed
  ## Examples

    iex> list_food_menus(%{})
    [%FoodMenu{}, ...]

  """
  def list_food_menus(filter_params = %{}) do
    filters =
      Enum.map(filter_params, fn
        {key, value} when is_binary(key) -> {String.to_existing_atom(key), value}
        key_value_pair -> key_value_pair
      end)
    list_food_menus(filters)
  end

  def list_food_menus(_filters = []) do
    Repo.all(FoodMenu)
  end

  def list_food_menus(filters) when is_list(filters) do
    {active, other_filters} = Keyword.pop(filters, :active, "false")
    query =
      case active do
        "true" ->
          from(food_menu in FoodMenu,
            where: ^other_filters,
            where: food_menu.valid_until >= ^DateTime.utc_now())
        "false" ->
          from(food_menu in FoodMenu,
            where: ^other_filters)

    end
    Repo.all(query)
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
