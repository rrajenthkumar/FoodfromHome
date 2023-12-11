defmodule FoodFromHome.Reviews do
  @moduledoc """
  The Reviews context.
  """
  alias FoodFromHome.Reviews.Finders.ReviewFromOrder
  alias FoodFromHome.Reviews.Finders.ReviewsFromSeller
  alias FoodFromHome.Reviews.Finders.AverageRatingFromSeller
  alias FoodFromHome.Reviews.ReviewRepo

  defdelegate create(order, attrs), to: ReviewRepo
  defdelegate update(review, attrs), to: ReviewRepo
  defdelegate delete(review), to: ReviewRepo

  def find_review_from_order(order), do: ReviewFromOrder.find(order)
  def list_reviews_from_seller(seller, filters), do: ReviewsFromSeller.list(seller, filters)
  def get_average_rating_from_seller(seller), do: AverageRatingFromSeller.get(seller)
end
