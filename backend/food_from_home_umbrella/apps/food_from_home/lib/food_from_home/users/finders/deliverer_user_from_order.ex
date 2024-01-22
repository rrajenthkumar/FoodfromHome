defmodule FoodFromHome.Users.Finders.DelivererUserFromOrder do
  @moduledoc """
  Finder to find a deliverer user from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Gets the user of type :deliverer related to an order

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> get!(%Order{id: 123})
      %User{}

      iex> get!(%Order{id: 456})
      ** (Ecto.NoResultsError)

  """
  def get!(%Order{id: order_id}) do
    query =
      from user in User,
        join: delivery in assoc(user, :deliverer_user),
        where: delivery.order_id == ^order_id

    Repo.one!(query)
  end
end
