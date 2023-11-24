defmodule FoodFromHome.FoodMenus.FoodMenuRepo do
  @moduledoc """
  CRUD operations related to food menus table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers
  alias FoodFromHome.Utils

  @doc """
  Creates a food_menu for a given seller id.

  ## Examples

      iex> create(%{field: value}, 12345)
      {:ok, %FoodMenu{}}

      iex> create(%{field: bad_value}, 12345)
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs, seller_id) when is_map(attrs) and is_integer(seller_id) do
    seller_id
    |> Sellers.get_seller!()
    |> Ecto.build_assoc(:food_menus, attrs)
    |> create_change()
    |> Repo.insert()
  end

  @doc """
  Gets a single food_menu using menu_id.

  Raises `Ecto.NoResultsError` if the Food menu does not exist.

  ## Examples

      iex> get!(123)
      %FoodMenu{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(menu_id) when is_integer(menu_id), do: Repo.get!(FoodMenu, menu_id)

  @doc """
  Updates a food_menu.
  If an associated cart item exists updation is forbidden and it results in ecto changeset error.

  ## Examples

      iex> update(%{field: new_value}, 12345)
      {:ok, %FoodMenu{}}

      iex> update(%{field: new_value}, 12345)
      {:error, %Ecto.Changeset{}}

  """
  def update(attrs = %{}, menu_id) when is_map(attrs) and is_integer(menu_id) do
    menu_id
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
      {:error, :forbidden}

  """
  def delete(menu_id) when is_integer(menu_id) do
    menu_id
    |> get!()
    |> no_associated_cart_items?()
    |> case do
      true -> Repo.delete()
      false -> {:error, :forbidden}
    end
  end

  @doc """
  Returns a list of food_menus for a given seller id and applicable filters.
  When 'active: true' filter is set, the food menus belonging to the seller, with quantity > 0 and which are still valid are displayed.

  ## Examples

    iex> list(12345)
    [%FoodMenu{}, ...]

  """
  def list(params_with_filters = %{"seller_id" => seller_id}) do
    filters =
      params_with_filters
      |> Map.drop("seller_id")
      |> Utils.convert_map_to_keyword_list()

    list(seller_id, filters)
  end

  def list(seller_id, filters) when is_integer(seller_id) and is_list(filters) do
    {active, other_filters} = Keyword.pop(filters, :active, "false")

    query =
      case active do
        "true" ->
          from(food_menu in FoodMenu,
            where: food_menu.seller_id == ^seller_id,
            where: food_menu.remaining_quantity > 0,
            where: food_menu.valid_until >= ^DateTime.utc_now())
        "false" ->
          from(food_menu in FoodMenu,
            where: food_menu.seller_id == ^seller_id)
      end
    Repo.all(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes during record creation.

  ## Examples

      iex> create_change(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def create_change(%FoodMenu{} = food_menu, attrs = %{} \\ %{}) do
    FoodMenu.changeset(food_menu, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_menu changes during record updation.

  ## Examples

      iex> update_change(food_menu)
      %Ecto.Changeset{data: %FoodMenu{}}

  """
  def update_change(%FoodMenu{} = food_menu, attr = %{} \\ %{}) do
    FoodMenu.changeset(food_menu, attrs)
  end

  defp no_associated_cart_items?(%FoodMenu{} = food_menu) do
    cart_item_count = Repo.aggregate(from cart_item in CartItem, where: cart_item.food_menu_id == ^food_menu.id, select: count(cart_item.id))
      if cart_item_count > 0 do
        false
      else
        true
      end
  end
end
