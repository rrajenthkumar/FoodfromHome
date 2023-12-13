defmodule FoodFromHome.Reviews.ReviewRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Reviews.Review

  @doc """
  Creates a review with an order.

  ## Examples

      iex> create_review(%Order{}, %{field: value})
      {:ok, %Review{}}

      iex> create_review(%Order{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(order = %Order{}, attrs) when is_map(attrs) do
    order
    |> Ecto.build_assoc(:review, attrs)
    |> change_create_review()
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(review = %Review{}, attrs) when is_map(attrs) do
    review
    |> change_update_review(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(review = %Review{}) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes during creation.

  ## Examples

      iex> change_create_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_create_review(review = %Review{}, attrs = %{} \\ %{}) do
    Review.create_changeset(review, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes during updation.

  ## Examples

      iex> change_update_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_update_review(review = %Review{}, attrs = %{} \\ %{}) do
    Review.update_changeset(review, attrs)
  end
end
