defmodule FoodFromHome.Users.Finders.DelivererUserFromOrder do
  @moduledoc """
  Finder to find a deliverer user from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Gets the user of type :deliverer related to an order.

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> find!(%Order{id: 123, user_type: :deliverer})
      %User{}

      iex> find!(%Order{id: 456, user_type: deliverer})
      ** (Ecto.NoResultsError)

  """
  def find!(%Order{id: order_id}) do
    query =
      from(user in User,
        join: delivery in assoc(user, :deliveries),
        join: order in assoc(delivery, :order),
        where: order.id == ^order_id)

    Repo.one!(query)
  end
end
