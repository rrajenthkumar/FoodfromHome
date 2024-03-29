defmodule FoodFromHome.Users.Finders.BuyerUserFromOrder do
  @moduledoc """
  Finder to find a buyer user from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Gets the user of type :buyer related to an order.

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> get!(%Order{id: 123})
      %User{}

      iex> get!(%Order{id: 456})
      ** (Ecto.NoResultsError)

  """
  def get!(%Order{buyer_user_id: buyer_user_id}) do
    query =
      from user in User,
        where: user.id == ^buyer_user_id

    Repo.one!(query)
  end
end
