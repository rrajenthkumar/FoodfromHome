defmodule FoodFromHome.Sellers.SellerRepo do
  @moduledoc """
  All CRUD operations related to sellers table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users

  @doc """
  Creates a seller.

  ## Examples

      iex> create_seller(%{field: value}, 45678)
      {:ok, %Seller{}}

      iex> create_seller(%{field: bad_value}, 45678)
      {:error, %Ecto.Changeset{}}

  """
  def create_seller(attrs \\ %{}, user_id) do
    user_id
    |> Users.get_user!()
    |> Ecto.build_assoc(:seller, attrs)
    |> change_seller()
    |> Repo.insert()
  end

  @doc """
  Gets a single seller.

  Raises `Ecto.NoResultsError` if the Seller does not exist.

  ## Examples

      iex> get_seller!(123)
      %Seller{}

      iex> get_seller!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seller!(seller_id), do: Repo.get!(Seller, seller_id)

    @doc """
  Gets a single seller using user id.

  Raises `Ecto.NoResultsError` if the Seller does not exist.

  ## Examples

      iex> get_seller_from_user_id!(123)
      %Seller{}

      iex> get_seller_from_user_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seller_with_user_id!(user_id) do
    query =
      from seller in Seller,
      where: seller.user_id == ^user_id

    Repo.one!(query)
  end

  @doc """
  Updates a seller.

  ## Examples

      iex> update_seller(45678, %{field: new_value})
      {:ok, %Seller{}}

      iex> update_seller(45678, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_seller(seller_id, attrs) do
    seller_id
    |> get_seller!()
    |> Seller.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking seller changes.

  ## Examples

      iex> change_seller(seller)
      %Ecto.Changeset{data: %Seller{}}

  """
  def change_seller(%Seller{} = seller, attrs \\ %{}) do
    Seller.changeset(seller, attrs)
  end
end
