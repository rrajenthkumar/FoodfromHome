defmodule FoodFromHome.Sellers.SellerRepo do
  @moduledoc """
  All necessary CRUD operations related to sellers table.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  @doc """
  Gets a single seller.

  Returns 'nil' if the Seller does not exist.

  ## Examples

      iex> get(123)
      %Seller{}

      iex> get(456)
      nil

  """
  def get(seller_id), do: Repo.get(Seller, seller_id)

  @doc """
  Gets a single seller.

  Raises `Ecto.NoResultsError` if the Seller does not exist.

  ## Examples

      iex> get!(123)
      %Seller{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(seller_id), do: Repo.get!(Seller, seller_id)

  @doc """
  Updates a seller.

  ## Examples

      iex> update(%Seller{}, %{field: new_value})
      {:ok, %Seller{}}

      iex> update(%Seller{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(seller = %Seller{}, attrs) do
    seller
    |> update_change(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking seller changes during record updation.

  ## Examples

      iex> update_change(seller)
      %Ecto.Changeset{data: %Seller{}}

  """
  def update_change(seller = %Seller{}, attrs = %{} \\ %{}) do
    Seller.update_changeset(seller, attrs)
  end
end
