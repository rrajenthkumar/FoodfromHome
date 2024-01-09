defmodule FoodFromHome.KafkaAgent.Consumer do
  @moduledoc """
  Kafka cosumer module
  """
  # use KafkaEx.Consumer

  # alias FoodFromHome.Notification

  # def handle_message({"order_confirmed", partition, offset, "order_id", order_id}) do
  # Notification.trigger(order_id, :order_confirmation_to_buyer)
  # Notification.trigger(order_id, :order_confirmation_to_seller)
  # end

  # def handle_message({"order_cancelled", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :order_cancellation_notification_to_buyer)
  # end

  # def handle_message({"payment_failed", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :payment_assistance_info_to_buyer)
  # end

  # def handle_message({"payment_cancelled", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :payment_assistance_info_to_buyer)
  # end

  # def handle_message({"delivery_started", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :delivery_tracking_info_to_buyer)
  # end

  # def handle_message({"delivery_completed", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :review_request_to_buyer)
  # end

  # def handle_message({"review_added", partition, offset, "order_id", order_id}) do
  #   Notification.trigger(order_id, :review_addition_notification_to_seller)
  # end
end
