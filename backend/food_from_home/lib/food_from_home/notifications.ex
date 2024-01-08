defmodule FoodFromHome.Notifications do
  @moduledoc """
  Module to manage notifications
  """
  alias FoodFromHome.Notifications.SendDeliveryTrackingEmailToBuyer
  alias FoodFromHome.Notifications.SendOrderCancellationEmailToBuyer
  alias FoodFromHome.Notifications.SendOrderConfirmationEmailToBuyer
  alias FoodFromHome.Notifications.SendOrderConfirmationEmailToSeller
  alias FoodFromHome.Notifications.SendPaymentAssistanceEmailToBuyer
  alias FoodFromHome.Notifications.SendReviewRequestEmailToBuyer
  alias FoodFromHome.Notifications.SendReviewSubmissionNotificationEmailToSeller

  def notify_buyer_about_order_confirmation(order_id) do
    SendOrderConfirmationEmailToBuyer.call(order_id)
  end

  def notify_seller_about_order_confirmation(order_id) do
    SendOrderConfirmationEmailToSeller.call(order_id)
  end

  def notify_about_order_cancellation(order_id) do
    SendOrderCancellationEmailToBuyer.call(order_id)
  end

  def send_payment_assistance_info(order_id) do
    SendPaymentAssistanceEmailToBuyer.call(order_id)
  end

  def send_delivery_tracking_info(order_id) do
    SendDeliveryTrackingEmailToBuyer.call(order_id)
  end

  def request_review(order_id) do
    SendReviewRequestEmailToBuyer.call(order_id)
  end

  def notify_about_review_submission(order_id) do
    SendReviewSubmissionNotificationEmailToSeller.call(order_id)
  end
end
