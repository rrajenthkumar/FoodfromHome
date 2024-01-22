defmodule FoodFromHome.Reviews.Services.CreateReviewAndProduceReviewAddedEvent do
  @moduledoc """
  Create a review for an order
  and produce a review_added Kafka event to be consumed by the notification module.
  """
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Reviews.ReviewRepo
  alias FoodFromHome.Reviews.Review

  def call(order = %Order{id: order_id, status: :delivered}, attrs) when is_map(attrs) do
    case ReviewRepo.create_review(order, attrs) do
      {:ok, %Review{}} = result ->
        case Producer.send_message("review_added", {"order_id", "#{order_id}"}) do
          :ok ->
            result

          {:error, kafka_error} ->
            {:error, 500,
             "Review created but 'review_added' Kafka event was not produced due to the following reason: #{kafka_error}"}
        end

      error ->
        error
    end
  end
end
