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

      iex> get_seller(123)
      %Seller{}

      iex> get_seller(456)
      nil

  """
  def get_seller(seller_id) when is_integer(seller_id) , do: Repo.get(Seller, seller_id)

  @doc """
  Gets a single seller.

  Raises `Ecto.NoResultsError` if the Seller does not exist.

  ## Examples

      iex> get_seller!(123)
      %Seller{}

      iex> get_seller!(456)
      ** (Ecto.NoResultsError)

  """
  def get_seller!(seller_id) when is_integer(seller_id) , do: Repo.get!(Seller, seller_id)
end
