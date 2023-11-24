defmodule FoodFromHome.Users.Finders.SellerUserFromOrder do
  @moduledoc """
  Finder to find the user record of a seller related to an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  @doc """
  Gets the user linked to a seller related to an order.

  Raises `Ecto.NoResultsError` if user is not found.

  ## Examples

      iex> find!(%Order{id: 123})
      %User{}

      iex> find!(%Order{id: 456})
      ** (Ecto.NoResultsError)

  """
  def find!(%Order{id: order_id}) do
    from(user in User,
      join: seller in assoc(user, :sellers),
      join: order in assoc(seller, :orders),
      where: order.id == ^order_id)
    |> Repo.one!()
  end
end
