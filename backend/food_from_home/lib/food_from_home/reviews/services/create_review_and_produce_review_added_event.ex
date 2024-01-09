defmodule FoodFromHome.Reviews.Services.CreateReviewAndProduceReviewAddedEvent do
  @moduledoc """
  Create a review for an order
  and produce a review_added Kafka event to be consumed by the notification module.
  """
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Reviews
  alias FoodFromHome.Reviews.Review

  def call(order = %Order{id: order_id, status: :delivered}, attrs) when is_map(attrs) do
    case Reviews.create_review(order, attrs) do
      {:ok, %Review{}} = result ->
        case Producer.send_message("review_added", {"order_id", "#{order_id}"}) do
          :ok -> result
          error -> error
        end

      error ->
        error
    end
  end
end
