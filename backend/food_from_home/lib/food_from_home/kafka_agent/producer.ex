defmodule FoodFromHome.KafkaAgent.Producer do
  @moduledoc """
  Kafka producer module

  Topics "order_confirmed", "order_cancelled", "payment_failed", "payment_cancelled", "delivery_started", "delivery_completed", "review_added" are used by the Notification module to trigger notification emails.

  Topics "sellers_searched", "seller_viewed", "food_menu_viewed" are used for seller metrics.
  """
  # @permitted_topics [
  #   "sellers_searched",
  #   "seller_viewed",
  #   "food_menu_viewed",
  #   "order_confirmed",
  #   "order_cancelled",
  #   "payment_failed",
  #   "payment_cancelled",
  #   "delivery_started",
  #   "delivery_completed",
  #   "review_added"
  # ]

  # def call(topic, key, message) when topic in @permitted_topics and is_binary(key) do
  #   KafkaEx.produce(topic, key, message)
  # end

  # def call(topic, _key, _message) when topic not in @permitted_topics do
  #   {:error, "The topic '#{topic}' is not permitted"}
  # end
end
