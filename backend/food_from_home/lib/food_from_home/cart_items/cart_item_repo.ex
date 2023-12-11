defmodule FoodFromHome.CartItems.CartItemRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Creates a cart_item with an order.

  ## Examples

      iex> create(%Order{}, %{field: new_value})
      {:ok, %CartItem{}}

      iex> create(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(order = %Order{}, attrs = %{} \\ %{}) do
    order
    |> Ecto.build_assoc(:cart_items, attrs)
    |> change_cart_item()
    |> Repo.update()
  end

  @doc """
  Gets a cart item using cart_item_id.

  Returns 'nil' if the cart item does not exist.

  ## Examples

      iex> get(123)
      %CartItem{}

      iex> get(456)
      nil

  """
  def get(cart_item_id) when is_integer(cart_item_id) do
    cart_item_id
    |> Repo.get(CartItem)
  end

  @doc """
  Gets a cart item using cart_item_id.

  Raises `Ecto.NoResultsError` if the cart item does not exist.

  ## Examples

      iex> get(123)
      %CartItem{}

      iex> get(456)
      ** (Ecto.NoResultsError)

  """
  def get!(cart_item_id) when is_integer(cart_item_id) do
    cart_item_id
    |> Repo.get!(CartItem)
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(cart_item = %CartItem{}, attrs = %{} \\ %{}) do
    cart_item
    |> change_cart_item(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart_item.

  ## Examples

      iex> delete(cart_item)
      {:ok, %CartItem{}}

      iex> delete(cart_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete(cart_item = %CartItem{}) do
    Repo.delete(cart_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart_item changes.

  ## Examples

      iex> change_cart_item(cart_item)
      %Ecto.Changeset{data: %CartItem{}}

  """
  def change_cart_item(cart_item = %CartItem{}, attrs = %{} \\ %{}) do
    CartItem.changeset(cart_item, attrs)
  end
end
