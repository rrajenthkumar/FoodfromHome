defmodule FoodFromHome.Notifications do
  @moduledoc """
  Module to manage order related notifications
  """
  def notify_order_confirmation(order_id) do
    IO.puts("*******************Order confirmation email*******************")
  end

  def notify_order_cancellation(order_id) do
    IO.puts("*******************Order cancellation info email*******************")
  end

  def send_payment_assistance_info(order_id) do
    IO.puts("*******************Payment assistance info email*******************")
  end

  def send_delivery_tracking_info(order_id) do
    IO.puts("*******************Delivery tracking info email*******************")
  end

  def request_review(order_id) do
    IO.puts("*******************Review request email*******************")
  end
end
