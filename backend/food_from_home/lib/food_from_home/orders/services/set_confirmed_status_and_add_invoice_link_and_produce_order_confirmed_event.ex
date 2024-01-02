defmodule FoodFromHome.Orders.Services.SetConfirmedStatusAndAddInvoiceLinkAndProduceOrderConfirmedEvent do
  @moduledoc """
  Used by payment module to change the status of an open order to :confirmed after payment is successful, add invoice link,
  and produce an order_confirmed Kafka event to be consumed by the notification module.
  """
  # alias FoodFromHome.KafkaAgent
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.OrderRepo

  def call(order = %Order{status: :open}, invoice_link) when is_binary(invoice_link) do
    case OrderRepo.update_order(order, %{status: :confirmed, invoice_link: invoice_link}) do
      {:ok, %Order{}} = result ->
        # KafkaAgent.produce_order_confirmed_event()
        result

      error ->
        error
    end
  end

  def call(%Order{status: another_status}, _invoice_link) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :open status can be confirmed."}
  end
end
