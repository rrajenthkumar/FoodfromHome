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

  def notify_buyer_about_order_confirmation(order) do
    SendOrderConfirmationEmailToBuyer.call(order)
  end

  def notify_seller_about_order_confirmation(order) do
    SendOrderConfirmationEmailToSeller.call(order)
  end

  def notify_about_order_cancellation(order) do
    SendOrderCancellationEmailToBuyer.call(order)
  end

  def send_payment_assistance_info(order) do
    SendPaymentAssistanceEmailToBuyer.call(order)
  end

  def send_delivery_tracking_info(order) do
    SendDeliveryTrackingEmailToBuyer.call(order)
  end

  def request_review(order) do
    SendReviewRequestEmailToBuyer.call(order)
  end

  def notify_about_review_submission(order) do
    SendReviewSubmissionNotificationEmailToSeller.call(order)
  end
end
