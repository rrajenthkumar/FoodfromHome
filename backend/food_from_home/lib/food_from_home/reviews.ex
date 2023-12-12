defmodule FoodFromHome.Reviews do
  @moduledoc """
  The Reviews context.
  Interface to all FoodMenu related methods for other contexts.
  """
  alias FoodFromHome.Reviews.Finders.ReviewFromOrder
  alias FoodFromHome.Reviews.Finders.ReviewsFromSeller
  alias FoodFromHome.Reviews.Finders.AverageRatingFromSeller
  alias FoodFromHome.Reviews.ReviewRepo

  defdelegate create_review(order, attrs), to: ReviewRepo
  defdelegate update_review(review, attrs), to: ReviewRepo
  defdelegate delete_review(review), to: ReviewRepo

  def get_review_from_order(order), do: ReviewFromOrder.get(order)
  def list_reviews_from_seller(seller, filters), do: ReviewsFromSeller.list(seller, filters)
  def get_average_rating_from_seller(seller), do: AverageRatingFromSeller.get(seller)
end
