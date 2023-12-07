defmodule FoodFromHome.Reviews.ReviewRepo do
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
  def create(order = %Order{}, attrs \\ %{}) do
    order
    |> Ecto.build_assoc(:review, attrs)
    |> change()
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
  def update(review = %Review{}, attrs) do
    review
    |> change(attrs)
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
  def delete(review = %Review{}) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end
end
