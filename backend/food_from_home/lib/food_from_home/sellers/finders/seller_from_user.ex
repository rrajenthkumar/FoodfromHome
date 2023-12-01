defmodule FoodFromHome.Sellers.Finders.SellerFromUser do
  @moduledoc """
  Finder to find a seller from a user
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Users.User
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Repo

  @doc """
  Gets a seller linked to an user.

  Raises `Ecto.NoResultsError` if the seller does not exist.

  ## Examples

    iex> find!(%User{id: 123})
    %Seller{}

    iex> find!(%User{id: 456})
    ** (Ecto.NoResultsError)

  """
  def find!(%User{id: user_id}) do
    query =
      from(seller in Seller,
        join: user in assoc(seller, :user),
        where: user.id == ^user_id)

    Repo.one!(query)
  end
end
