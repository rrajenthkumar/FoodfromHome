defmodule FoodFromHome.Deliveries.DeliveryRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Associates an order and creates a delivery.

  ## Examples

      iex> create_delivery(%Order{}, %{field: value})
      {:ok, %Delivery{}}

      iex> create_delivery(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_delivery(order = %Order{}, attrs = %{} \\ %{}) do
    order
    |> Ecto.build_assoc(:delivery, attrs)
    |> change_create()
    |> Repo.insert()
  end

  @doc """
  Updates a delivery.

  ## Examples

      iex> update_delivery(delivery, %{field: new_value})
      {:ok, %Delivery{}}

      iex> update(delivery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_delivery(delivery = %Delivery{}, attrs = %{}) do
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
