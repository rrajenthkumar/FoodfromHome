defmodule FoodFromHome.Kaffe.Producer do
  @moduledoc """
  Kafka producer module

  Topics "order_confirmed", "order_cancelled", "payment_failed", "payment_cancelled", "delivery_started", "delivery_completed", "review_added" are used by the Notification module to trigger notification emails.

  Topics "sellers_searched", "seller_viewed", "food_menu_viewed" are used for seller metrics.
  """
  @permitted_topics [
    "sellers_searched",
    "seller_viewed",
    "food_menu_viewed",
    "order_confirmed",
    "order_cancelled",
    "payment_failed",
    "payment_cancelled",
    "delivery_started",
    "delivery_completed",
    "review_added"
  ]

  def send_message(topic, {key, value}) when topic in @permitted_topics do
    Kaffe.Producer.produce_sync(topic, [{key, value}])
  end

  def send_message(topic, {_key, _value}) when topic not in @permitted_topics do
    {:error, "The topic '#{topic}' is not permitted"}
  end
end
