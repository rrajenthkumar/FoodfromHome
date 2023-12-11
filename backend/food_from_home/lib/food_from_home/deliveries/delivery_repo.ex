defmodule FoodFromHome.Deliveries.DeliveryRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Associates an order and creates a delivery.

  ## Examples

      iex> create(%Order{}, %{field: value})
      {:ok, %Delivery{}}

      iex> create(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(order = %Order{}, attrs = %{} \\ %{}) do
    order
    |> Ecto.build_assoc(:delivery, attrs)
    |> change_create()
    |> Repo.insert()
  end

  @doc """
  Gets a delivery using order id.

  Raises `Ecto.NoResultsError` if the Delivery does not exist.

  ## Examples

      iex> get_with_order_id!(123)
      %Delivery{}

      iex> get_with_order_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_with_order_id!(order_id) when is_integer(order_id) do
    query =
      from delivery in Delivery,
        where: delivery.order_id == ^order_id

    Repo.one!(query)
  end

  @doc """
  Updates a delivery.

  ## Examples

      iex> update(delivery, %{field: new_value})
      {:ok, %Delivery{}}

      iex> update(delivery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(delivery = %Delivery{}, attrs = %{}) do
    delivery
    |> change_update(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery creation changes.

  ## Examples

      iex> change_create(delivery)
      %Ecto.Changeset{data: %Delivery{}}

  """
  def change_create(delivery = %Delivery{}, attrs = %{} \\ %{}) do
    Delivery.create_changeset(delivery, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery updation changes.

  ## Examples

      iex> change_update(delivery)
      %Ecto.Changeset{data: %Delivery{}}

  """
  def change_update(delivery = %Delivery{}, attrs = %{} \\ %{}) do
    Delivery.update_changeset(delivery, attrs)
  end
end
