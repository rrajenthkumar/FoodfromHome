defmodule FoodFromHome.Reviews do
  @moduledoc """
  The Reviews context.
  """
  alias FoodFromHome.Reviews.Finders.ReviewFromOrder
  alias FoodFromHome.Reviews.ReviewRepo
  alias FoodFromHome.Reviews.Services.IsReviewRelatedToUser

  defdelegate create(order, attrs), to: ReviewRepo
  defdelegate list(seller_id), to: ReviewRepo
  defdelegate update(review, attrs), to: ReviewRepo
  defdelegate delete(review), to: ReviewRepo

  def find_review_from_order(order), do: ReviewFromOrder.find(order)
end
