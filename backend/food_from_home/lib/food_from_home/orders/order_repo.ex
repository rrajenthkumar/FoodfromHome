defmodule FoodFromHome.Orders.OrderRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @doc """
  Creates an order linked to a buyer.

  ## Examples

      iex> create_order(%User{}, %{field: value})
      {:ok, %Order{}}

      iex> create_order(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(
        buyer_user = %User{address: default_delivery_address, user_type: :buyer},
        attrs
      )
      when is_map(attrs) do
    default_delivery_address_map = Map.from_struct(default_delivery_address)

    attrs_with_default_delivery_address =
      Map.put(attrs, :delivery_address, default_delivery_address_map)

    buyer_user
    |> Ecto.build_assoc(:orders, attrs_with_default_delivery_address)
    |> change_create()
    |> Repo.insert()
  end

  @doc """
  Returns a list of related orders for a user of type :seller or :buyer with applicable filters.
  Returns a list of orders with status :ready_for_pickup in the same city for a given user of type :deliverer with applicable filters.

  ## Examples

    iex> list_order(%User{}, [])
    [%Order{}, ...]

  """

  def list_order(user = %User{user_type: :seller}, filters) when is_list(filters) do
    %Seller{id: seller_id} = Sellers.get_seller_from_user!(user)

    query =
      from(order in Order,
        where: ^filters,
        where: order.seller_id == ^seller_id
      )

    Repo.all(query)
  end

  def list_order(%User{id: user_id, user_type: :buyer}, filters) when is_list(filters) do
    query =
      from(order in Order,
        where: ^filters,
        where: order.buyer_user_id == ^user_id
      )

    Repo.all(query)
  end

  def list_order(%User{user_type: :deliverer, address: %Address{city: deliverer_city}}, filters)
      when is_list(filters) do
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

      iex> get_order(123)
      %Order{}

      iex> get_order(456)
      nil

  """
  def get_order(order_id) when is_integer(order_id), do: Repo.get(Order, order_id)

  @doc """
  Gets an order using order_id.

  Raises `Ecto.NoResultsError` if the order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(order_id) when is_integer(order_id), do: Repo.get!(Order, order_id)

  @doc """
  Updates an order.

  ## Examples

      iex> update_order(%Order{}, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(order = %Order{}, attrs) when is_map(attrs) do
    order
    |> change_update(attrs)
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
  def delete_order(order = %Order{status: :open}) do
    Repo.delete(order)
  end

  def delete_order(%Order{}) do
    {:error, 403, "Only an order of :open status can be deleted"}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record creation.

  ## Examples

      iex> change_create(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_create(order = %Order{}, attrs = %{} \\ %{}) do
    Order.create_changeset(order, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes during record updation.

  ## Examples

      iex> change_update(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_update(order = %Order{}, attrs = %{} \\ %{}) do
    Order.update_changeset(order, attrs)
  end
end
