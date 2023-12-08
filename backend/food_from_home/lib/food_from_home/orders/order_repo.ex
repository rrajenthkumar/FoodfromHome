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
    buyer_user = %User{address: default_delivery_address} = Users.get!(buyer_user_id)

    default_delivery_address_map = Map.from_struct(default_delivery_address)

    attrs_with_default_delivery_address =  Map.put(attrs, :delivery_address, default_delivery_address_map)

    buyer_user
    |> Ecto.build_assoc(:orders, attrs_with_default_delivery_address)
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
        where: order.seller_id == ^seller_id)

    Repo.all(query)
  end

  def list(%User{id: user_id, user_type: :buyer}, filters) when is_list(filters) do
    query =
      from(order in Order,
        where: ^filters,
        where: order.buyer_user_id == ^user_id)

    Repo.all(query)
  end

  def list(%User{user_type: :deliverer, address: %Address{city: deliverer_city}}, filters) when is_list(filters) do
    query =
      from order in Order,
        join: delivery_address in assoc(order, :delivery_address),
        where: ^filters,
        where: order.status == :ready_for_pickup,
        where: delivery_address.city == ^deliverer_city

    Repo.all(query)
  end

  @doc """
  Gets an order using order_id.

  Returns 'nil' if the order does not exist.

  ## Examples

      iex> get(123)
      %Order{}

      iex> get(456)
      nil

  """
  def get(order_id) when is_integer(order_id) do
    order_id
    |> Repo.get(Order)
    |> case do
      nil -> nil
      order -> Repo.preload([:delivery, :review, cart_items: [:food_menus]])
    end
  end

  @doc """
  Gets an order using order_id.

  Raises `Ecto.NoResultsError` if the order does not exist.

  ## Examples

      iex> get!(123)
      %Order{}

      iex> get!(456)
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
  Deletes an open order along with cart items.

  ## Examples

      iex> delete_order(%Order{status: :open})
      {:ok, %Order{}}

      iex> delete_order(%Order{status: :confirmed})
      {:error, 403, "Only an order of :open status can be deleted"}

  """
  def delete(order = %Order{status: :open}) do
    Repo.delete(order)
  end

  def delete(%Order{}) do
    {:error, 403, "Only an order of :open status can be deleted"}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record creation.

  ## Examples

      iex> create_change(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def create_change(order = %Order{}, attrs = %{} \\ %{}) do
    Order.create_changeset(order, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record updation.

  ## Examples

      iex> update_change(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def update_change(order = %Order{}, attrs = %{} \\ %{}) do
    Order.update_changeset(order, attrs)
  end
end
