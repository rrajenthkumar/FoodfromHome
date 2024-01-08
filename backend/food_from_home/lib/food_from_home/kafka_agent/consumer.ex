defmodule FoodFromHome.KafkaAgent.Consumer do
  @moduledoc """
  Kafka cosumer module
  """
  use KafkaEx.Consumer

  alias FoodFromHome.Notifications

  def handle_message({"order_confirmed", partition, offset, "order_id", order_id}) do
    Notifications.notify_order_confirmation(order_id)
  end

  def handle_message({"order_cancelled", partition, offset, "order_id", order_id}) do
    Notifications.notify_order_cancellation(order_id)
  end

  def handle_message({"payment_failed", partition, offset, "order_id", order_id}) do
    Notifications.send_payment_assistance_info(order_id)
  end

  def handle_message({"payment_cancelled", partition, offset, "order_id", order_id}) do
    Notifications.send_payment_assistance_info(order_id)
  end

  def handle_message({"delivery_started", partition, offset, "order_id", order_id}) do
    Notifications.send_delivery_tracking_info(order_id)
  end

  def handle_message({"delivery_completed", partition, offset, "order_id", order_id}) do
    Notifications.request_review(order_id)
  end
end
