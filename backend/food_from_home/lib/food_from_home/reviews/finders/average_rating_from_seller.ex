defmodule FoodFromHome.Reviews.Finders.AverageRatingFromSeller do
  import Ecto.Query, warn: false

  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Repo

  def get(%Seller{id: seller_id}) do
    query =
      from review in Review,
        join: order in assoc(review, :order),
        join: seller in assoc(order, :seller),
        where: seller.id == ^seller_id,
        select: avg(review.rating)

    query
    |> Repo.one()
    |> Float.round()
  end
end
