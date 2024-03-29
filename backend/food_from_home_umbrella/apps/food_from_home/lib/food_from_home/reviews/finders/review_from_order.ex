defmodule FoodFromHome.Reviews.Finders.ReviewFromOrder do
  @moduledoc """
  To get a review from an order
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo
  alias FoodFromHome.Reviews.Review

  @doc """
  Gets a review linked to an order.

  Raises nil if the review does not exist.

  ## Examples

    iex> find(%Order{id: 123})
    %Review{}

    iex> find(%Order{id: 456})
    nil

  """
  def get(%Order{id: order_id}) do
    query =
      from(review in Review,
        join: order in assoc(review, :order),
        where: order.id == ^order_id
      )

    Repo.one(query)
  end
end
