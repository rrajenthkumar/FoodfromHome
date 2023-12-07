defmodule FoodFromHome.CartItems.CartItemRepo do
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Orders.Order

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
  def change_cart_item(%CartItem{} = cart_item, attrs \\ %{}) do
    CartItem.create_changeset(cart_item, attrs)
  end
end
