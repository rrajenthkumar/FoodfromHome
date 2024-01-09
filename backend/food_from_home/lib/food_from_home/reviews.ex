defmodule FoodFromHome.Reviews do
  @moduledoc """
  The Reviews context.
  Interface to all FoodMenu related methods for other contexts.
  """
  alias FoodFromHome.Reviews.Finders.ReviewFromOrder
  alias FoodFromHome.Reviews.Finders.ReviewsFromSeller
  alias FoodFromHome.Reviews.Finders.AverageRatingFromSeller
  alias FoodFromHome.Reviews.ReviewRepo
  alias FoodFromHome.Reviews.Services.CreateReviewAndProduceReviewAddedEvent
  alias FoodFromHome.Reviews.Utils

  def create_review(order, attrs), do: CreateReviewAndProduceReviewAddedEvent.call(order, attrs)

  defdelegate update_review(review, attrs), to: ReviewRepo
  defdelegate delete_review(review), to: ReviewRepo

  def get_review_from_order(order), do: ReviewFromOrder.get(order)
  def list_reviews_from_seller(seller, filters), do: ReviewsFromSeller.list(seller, filters)
  def get_average_rating_from_seller(seller), do: AverageRatingFromSeller.get(seller)

  defdelegate is_review_older_than_a_day?(review), to: Utils
end
