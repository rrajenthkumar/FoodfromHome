defmodule FoodFromHome.Orders.Finders.OrderFromReview do
  @moduledoc """
  Finder to find an order from a review
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Orders

  @doc """
  Gets an order linked to an review.

  Raises `Ecto.NoResultsError` if the order does not exist.

  ## Examples

    iex> find!(%Review{id: 123})
    %Order{}

    iex> find!(%Review{id: 456})
    ** (Ecto.NoResultsError)

  """
  def find!(%Review{order_id: order_id}) do
    Orders.get!(order_id)
  end
end
