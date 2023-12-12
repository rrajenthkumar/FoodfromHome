defmodule FoodFromHomeWeb.ReviewJSON do
  alias FoodFromHome.Reviews.Review

  @doc """
  Renders a list of reviews.
  """
  def index(%{reviews: reviews}) do
    %{data: for(review <- reviews, do: limited_data(review))}
  end

  @doc """
  Renders a single review.
  """
  def show(%{review: review}) do
    %{data: data(review)}
  end

  defp limited_data(review = %Review{}) do
    %{
      id: review.id,
      rating: review.rating,
      buyer_note: review.buyer_note,
      seller_reply: review.seller_reply
    }
  end

  defp data(review = %Review{}) do
    %{
      id: review.id,
      date: review.updated_at,
      order_id: review.order_id,
      rating: review.rating,
      buyer_note: review.buyer_note,
      seller_reply: review.seller_reply
    }
  end
end
