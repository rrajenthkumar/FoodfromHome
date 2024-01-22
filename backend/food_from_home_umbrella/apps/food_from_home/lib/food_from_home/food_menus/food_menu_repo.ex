defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  CRUD operations related to food menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  @doc """
  Creates a food menu for a seller.

  ## Examples

      iex> create_food_menu(%Seller{}, %{field: value})
      {:ok, %FoodMenu{}}

      iex> create_food_menu(%Seller{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_food_menu(seller = %Seller{}, attrs) when is_map(attrs) do
    seller
    |> Ecto.build_assoc(:food_menus, attrs)
    |> change_create()
    |> Repo.insert()
  end

  @doc """
  Returns a list of food menus for a given seller and applicable filters.
  When 'active: true' filter is set, the food menus belonging to the seller, with quantity > 0 and which are still valid are displayed.

  ## Examples

    iex> list_food_menu(%Seller{}, [])
    [%FoodMenu{}, ...]

  """

  def list_food_menu(%Seller{id: seller_id}, filters) when is_list(filters) do
    {active, other_filters} = Keyword.pop(filters, :active, "false")

    query =
      case active do
        "true" ->
          from(food_menu in FoodMenu,
            where: ^other_filters,
            where: food_menu.seller_id == ^seller_id,
            where: food_menu.remaining_quantity > 0,
            where: food_menu.valid_until >= ^DateTime.utc_now()
          )

        "false" ->
          from(food_menu in FoodMenu,
            where: ^other_filters,
            where: food_menu.seller_id == ^seller_id
          )
      end

    Repo.all(query)
  end

  @doc """
  Gets a food menu with food_menu_id.

  Returns 'nil' when the food menu does not exist.

  ## Examples

      iex> get_food_menu(123)
      %FoodMenu{}

      iex> get_food_menu(456)
      nil

  """
  def get_food_menu(food_menu_id) when is_integer(food_menu_id),
    do: Repo.get(FoodMenu, food_menu_id)

  @doc """
  Gets a food menu with food_menu_id.

  Raises `Ecto.NoResultsError` if the food menu does not exist.

  ## Examples

      iex> get_food_menu!(123)
      %FoodMenu{}

      iex> get_food_menu!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_menu!(food_menu_id) when is_integer(food_menu_id),
    do: Repo.get!(FoodMenu, food_menu_id)

  @doc """
  Updates a food menu.

  ## Examples

      iex> update_food_menu(%FoodMenu{}, %{field: new_value})
      {:ok, %FoodMenu{}}

      iex> update_food_menu(%FoodMenu{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_menu(food_menu = %FoodMenu{}, attrs) when is_map(attrs) do
    food_menu
    |> change_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food menu.
  If an associated cart item exists deletion is forbidden.

  ## Examples

      iex> delete_food_menu(%FoodMenu{})
      {:ok, %FoodMenu{}}

      iex> delete_food_menu(%FoodMenu{})
      {:error, 403, "An associated cart item exists"}

  """
  def delete_food_menu(food_menu = %FoodMenu{}) do
    case FoodMenus.has_associated_cart_items?(food_menu) do
      true -> {:error, 403, "An associated cart item exists"}
      false -> Repo.delete(food_menu)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food menu changes during record creation.

  ## Examples

      iex> change_create(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def change_create(food_menu = %FoodMenu{}, attrs = %{} \\ %{}) do
    FoodMenu.create_changeset(food_menu, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes during record updation.

  ## Examples

      iex> change_update(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def change_update(food_menu = %FoodMenu{}, attrs = %{} \\ %{}) do
    FoodMenu.update_changeset(food_menu, attrs)
  end
end
