defmodule FoodFromHome.Deliveries.DeliveryRepo do
  import Ecto.Query, warn: false

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Deliveries
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
  def create(order = %Order{}, attrs \\ %{}) do
    order
    |> Ecto.build_assoc(:delivery, attrs)
    |> change_create()
    |> Repo.insert()
  end

  @doc """
  Gets a single delivery from delivery id.

  Raises `Ecto.NoResultsError` if the Delivery does not exist.

  ## Examples

      iex> get!(123)
      %Delivery{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(delivery_id), do: Repo.get!(Delivery, delivery_id)


  @doc """
  Updates a delivery linked to an order.

  ## Examples

      iex> update(delivery, %{field: new_value})
      {:ok, %Delivery{}}

      iex> update(delivery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(order = %Order{}, attrs) do

    Deliveries.find_delivery_from_order!(order)
    |> change_update(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery creation changes.

  ## Examples

      iex> change_create(delivery)
      %Ecto.Changeset{data: %Delivery{}}

  """
  def change_create(%Delivery{} = delivery, attrs \\ %{}) do
    Delivery.create_changeset(delivery, attrs)
  end

    @doc """
  Returns an `%Ecto.Changeset{}` for tracking delivery updation changes.

  ## Examples

      iex> change_update(delivery)
      %Ecto.Changeset{data: %Delivery{}}

  """
  def change_update(%Delivery{} = delivery, attrs \\ %{}) do
    Delivery.update_changeset(delivery, attrs)
  end
end
