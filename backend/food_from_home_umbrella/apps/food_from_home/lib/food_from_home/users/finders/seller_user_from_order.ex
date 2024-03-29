defmodule FoodFromHome.Users.Finders.SellerUserFromOrder do
  @moduledoc """
  Finder to find a seller user from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Gets the user of type :seller related to an order along with seller details.

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> get!(%Order{id: 123})
      %User{}

      iex> get!(%Order{id: 456})
      ** (Ecto.NoResultsError)

  """
  def get!(%Order{seller_id: seller_id}) do
    query =
      from user in User,
        join: seller in assoc(user, :seller_user),
        where: seller.id == ^seller_id,
        preload: [seller: seller]

    Repo.one!(query)
  end
end
