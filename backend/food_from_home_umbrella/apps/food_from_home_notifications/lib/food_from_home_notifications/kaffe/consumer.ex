defmodule FoodFromHomeNotifications.Kaffe.Consumer do
  @moduledoc """
  Kafka cosumer module
  """
  alias FoodFromHomeNotifications.Notification

  def handle_message(%{topic: "order_confirmed", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :order_confirmation_to_buyer)
    Notification.trigger(order_id, :order_confirmation_to_seller)
  end

  def handle_message(%{topic: "order_cancelled", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :order_cancellation_notification_to_buyer)
  end

  def handle_message(%{topic: "payment_failed", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :payment_assistance_info_to_buyer)
  end

  def handle_message(%{topic: "payment_cancelled", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :payment_assistance_info_to_buyer)
  end

  def handle_message(%{topic: "delivery_started", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :delivery_tracking_info_to_buyer)
  end

  def handle_message(%{topic: "delivery_completed", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :review_request_to_buyer)
  end

  def handle_message(%{topic: "review_added", key: "order_id", value: order_id}) do
    Notification.trigger(order_id, :review_addition_notification_to_seller)
  end
end
