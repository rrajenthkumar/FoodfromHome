defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  CRUD operations related to food menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers

  @doc """
  Creates a food_menu for a given seller id.

  ## Examples

      iex> create(12345, %{field: value})
      {:ok, %FoodMenu{}}

      iex> create(12345, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(seller_id, attrs) when is_integer(seller_id) and is_map(attrs) do
    seller_id
    |> Sellers.get!()
    |> Ecto.build_assoc(:food_menus, attrs)
    |> create_change()
    |> Repo.insert()
  end

  @doc """
  Returns a list of food_menus for a given seller id and applicable filters.
  When 'active: true' filter is set, the food menus belonging to the seller, with quantity > 0 and which are still valid are displayed.

  ## Examples

    iex> list(12345)
    [%FoodMenu{}, ...]

  """

  def list(seller_id, filters) when is_integer(seller_id) and is_list(filters) do
    {active, other_filters} = Keyword.pop(filters, :active, "false")

    query =
      case active do
        "true" ->
          from(food_menu in FoodMenu,
            where: ^other_filters,
            where: food_menu.seller_id == ^seller_id,
            where: food_menu.remaining_quantity > 0,
            where: food_menu.valid_until >= ^DateTime.utc_now())
        "false" ->
          from(food_menu in FoodMenu,
            where: ^other_filters,
            where: food_menu.seller_id == ^seller_id)
      end
    Repo.all(query)
  end

  @doc """
  Gets a food_menu with food_menu_id.

  Raises `Ecto.NoResultsError` if the Food menu does not exist.

  ## Examples

      iex> get!(123)
      %FoodMenu{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(food_menu_id) when is_integer(food_menu_id), do: Repo.get!(FoodMenu, food_menu_id)

  @doc """
  Updates a food_menu.
  If an associated cart item exists updation is forbidden and it results in ecto changeset error.

  ## Examples

      iex> update(12345, %{field: new_value})
      {:ok, %FoodMenu{}}

      iex> update(12345, %{field: new_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(food_menu_id, attrs) when is_map(attrs) and is_integer(food_menu_id) do
    food_menu_id
    |> get!()
    |> update_change(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_menu.
  If an associated cart item exists deletion is forbidden.

  ## Examples

      iex> delete(12345)
      {:ok, %FoodMenu{}}

      iex> delete(12345)
      {:error, 403, "An associated cart item exists"}

  """
  def delete(food_menu_id) when is_integer(food_menu_id) do
    food_menu = get!(food_menu_id)

    case no_associated_cart_items?(food_menu) do
      true -> Repo.delete(food_menu)
      false -> {:error, 403, "An associated cart item exists"}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes during record creation.

  ## Examples

      iex> create_change(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def create_change(%FoodMenu{} = food_menu, attrs = %{} \\ %{}) do
    FoodMenu.create_changeset(food_menu, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes during record updation.

  ## Examples

      iex> update_change(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def update_change(%FoodMenu{} = food_menu, attrs = %{} \\ %{}) do
    FoodMenu.update_changeset(food_menu, attrs)
  end

  defp no_associated_cart_items?(%FoodMenu{} = food_menu) do
    query =
      from cart_item in CartItem,
        where: cart_item.food_menu_id == ^food_menu.id

    cart_item_count = Repo.aggregate(query, :count, :id)

    if cart_item_count > 0 do
      false
    else
      true
    end
  end
end
