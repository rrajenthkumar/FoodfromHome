defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Sellers context.
  """

  import Ecto.Query, warn: false
  alias FoodFromHome.Repo

  alias FoodFromHome.Sellers.Seller

  @doc """
  Returns the list of sellers.

  ## Examples

      iex> list_sellers()
      [%Seller{}, ...]

  """
  def list_sellers do
    Repo.all(Seller)
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
  def get_seller!(id), do: Repo.get!(Seller, id)

  @doc """
  Creates a seller.

  ## Examples

      iex> create_seller(%{field: value})
      {:ok, %Seller{}}

      iex> create_seller(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_seller(attrs \\ %{}) do
    %Seller{}
    |> Seller.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a seller.

  ## Examples

      iex> update_seller(seller, %{field: new_value})
      {:ok, %Seller{}}

      iex> update_seller(seller, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_seller(%Seller{} = seller, attrs) do
    seller
    |> Seller.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a seller.

  ## Examples

      iex> delete_seller(seller)
      {:ok, %Seller{}}

      iex> delete_seller(seller)
      {:error, %Ecto.Changeset{}}

  """
  def delete_seller(%Seller{} = seller) do
    Repo.delete(seller)
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
