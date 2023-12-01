defmodule FoodFromHome.Users.Finders.BuyerUserFromOrder do
  @moduledoc """
  Finder to find a buyer user from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  @doc """
  Gets the user of type :buyer related to an order.

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> find!(%Order{id: 123, user_type: :buyer})
      %User{}

      iex> find!(%Order{id: 456, user_type: buyer})
      ** (Ecto.NoResultsError)

  """
  def find!(%Order{buyer_user_id: buyer_user_id}) do
    query =
      from(user in User,
        where: id == ^buyer_user_id)

    Repo.one!(query)
  end
end
