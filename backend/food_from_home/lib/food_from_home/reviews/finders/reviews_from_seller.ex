defmodule FoodFromHome.Reviews.Finders.ReviewsFromSeller do
  @moduledoc """
  Finder to list deliveries from a seller with applicable filters
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller

  @doc """
  Returns a list of reviews for a seller with applicable filters.

  ## Examples

    iex> list(%Seller{}, [])
    [%Review{}, ...]

  """

  def list(%Seller{id: seller_id}, filters) when is_list(filters) do
    query =
      from(review in Review,
        join: order in assoc(review, :order),
        join: seller in assoc(order, :seller),
        where: ^filters,
        where: seller.id == ^seller_user_id)

    Repo.all(query)
  end
end
