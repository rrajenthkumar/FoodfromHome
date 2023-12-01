defmodule FoodFromHome.Orders.OrderRepo do
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @doc """
  Creates an order linked to a buyer.

  ## Examples

      iex> create(12345, %{field: value})
      {:ok, %Order{}}

      iex> create(6789, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(buyer_user_id, attrs) when is_integer(buyer_user_id) and is_map(attrs) do
    buyer_user_id
    |> Users.get!()
    |> Ecto.build_assoc(:orders, attrs)
    |> create_change()
    |> Repo.insert()
  end

  @doc """
  Returns a list of related orders for a user of type :seller or :buyer with applicable filters.
  Returns a list of orders with status :ready_for_pickup in the same city for a given user of type :deliverer with applicable filters.

  ## Examples

    iex> list(%User{}, [])
    [%Order{}, ...]

  """

  def list(user = %User{user_type: :seller}, filters) when is_list(filters) do
    %Seller{id: seller_id} = Sellers.find_seller_from_user!(user)

    query =
      from(order in Order,
        where: ^filters,
        where: Order.seller_id == ^seller_id)

    Repo.all(query)
  end

  def list(user = %User{id: user_id, user_type: :buyer}, filters) when is_list(filters) do
    query =
      from(order in Order,
        where: ^filters,
        where: order.buyer_user_id == ^user_id)

    Repo.all(query)
  end

  def list(user = %User{user_type: :deliverer, address: %Address{city: deliverer_city}}, filters) when is_list(filters) do
    query =
      from(order in Order,
        where: ^filters,
        where: order.delivery_address.city == ^deliverer_city,
        where: status == :ready_for_pickup)

    Repo.all(query)
  end

  @doc """
  Gets an order using order_id.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(order_id) when is_integer(order_id) do
    order_id
    |> Repo.get!(Order)
    |> Repo.preload([:delivery, :review, cart_items: [:food_menus]])
  end

  @doc """
  Updates an order.

  ## Examples

      iex> update_order(%Order{}, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(order = %Order{}, attrs) when is_map(attrs) do
    order
    |> update_change(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an open order.

  ## Examples

      iex> delete_order(%Order{status: :open})
      {:ok, %Order{}}

      iex> delete_order(%Order{status: :confirmed})
      {:error, :forbidden}

  """
  def delete(order = %Order{status: :open}) do
    Repo.delete(order)
  end

  def delete(order = %Order{}) do
    {:error, :forbidden}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record creation.

  ## Examples

      iex> create_change(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def create_change(order = %Order{}, attrs) when is_map(attrs) do
    Order.create_changeset(order, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record updation.

  ## Examples

      iex> update_change(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def update_change(order = %Order{}, attrs) when is_map(attrs) do
    Order.update_changeset(order, attrs)
  end
end
