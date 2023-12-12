defmodule FoodFromHome.Reviews.Finders.AverageRatingFromSeller do
  @moduledoc """
  To find the average rating for a seller from the reviews of his orders
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller

  def get(%Seller{id: seller_id}) do
    query =
      from review in Review,
        join: order in assoc(review, :order),
        join: seller in assoc(order, :seller),
        where: seller.id == ^seller_id,
        select: avg(review.rating)

    query
    |> Repo.one()
    |> case do
      nil -> nil
      average_rating -> Float.round(average_rating)
    end
  end
end
