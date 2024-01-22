defmodule FoodFromHome.Orders.Services.SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent do
  @moduledoc """
  Used by payment module to change the status of an open order to :confirmed after payment is successful, add invoice link,
  and produce an order_confirmed Kafka event to be consumed by the notification module.
  """
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.OrderRepo

  def call(order = %Order{id: order_id, status: :open}, invoice_link)
      when is_binary(invoice_link) do
    case OrderRepo.update_order(order, %{status: :confirmed, invoice_link: invoice_link}) do
      {:ok, %Order{}} = result ->
        case Producer.send_message("order_confirmed", {"order_id", "#{order_id}"}) do
          :ok ->
            result

          {:error, kafka_error} ->
            {:error, 500,
             "Order updated but 'order_confirmed' Kafka event was not produced due to the following reason: #{kafka_error}"}
        end

      error ->
        error
    end
  end

  def call(%Order{status: another_status}, _invoice_link) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :open status can be confirmed."}
  end
end
