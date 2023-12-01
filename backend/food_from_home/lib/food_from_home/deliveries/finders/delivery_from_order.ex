defmodule FoodFromHome.Deliveries.Finders.DeliveryFromOrder do
  @moduledoc """
  Finder to find a delivery from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Gets a order linked to a delivery.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

    iex> find!(%Order{id: 123})
    %Delivery{}

    iex> find!(%Order{id: 456})
    ** (Ecto.NoResultsError)

  """
  def find!(%Order{id: order_id}) do
    query =
      from(delivery in Delivery,
        join: order in assoc(delivery, :order),
        where: order.id == ^order_id)

    Repo.one!(query)
  end
end
