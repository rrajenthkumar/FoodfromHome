defmodule FoodFromHome.Sellers.Finders.SellerFromUser do
  @moduledoc """
  Finder to get a seller from a user of type :seller
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  @doc """
  Gets a seller from an user.

  Raises `Ecto.NoResultsError` if the seller does not exist.

  ## Examples

    iex> get!(%User{id: 123})
    %Seller{}

    iex> get!(%User{id: 456})
    ** (Ecto.NoResultsError)

  """
  def get!(%User{id: user_id, user_type: :seller}) do
    query =
      from(seller in Seller,
        join: seller_user in assoc(seller, :seller_user),
        where: seller_user.id == ^user_id
      )

    Repo.one!(query)
  end
end
