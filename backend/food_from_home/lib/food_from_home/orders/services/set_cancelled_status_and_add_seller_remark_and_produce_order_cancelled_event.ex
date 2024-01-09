defmodule FoodFromHome.Orders.Services.SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent do
  @moduledoc """
  Used by seller to change the status of an open order to :cancelled in case of some difficulty in honouring the order, add seller remark, and produce an order_cancelled Kafka event to be consumed by the notification module.
  """
  alias FoodFromHome.Kaffe.Producer
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.OrderRepo

  def call(order = %Order{id: order_id, status: :open}, seller_remark)
      when is_binary(seller_remark) do
    case OrderRepo.update_order(order, %{status: :cancelled, seller_remark: seller_remark}) do
      {:ok, %Order{}} = result ->
        case Producer.send_message("order_cancelled", {"order_id", "#{order_id}"}) do
          :ok -> result
          error -> error
        end

      error ->
        error
    end
  end

  def call(%Order{status: another_status}, _seller_remark) do
    {:error, 403,
     "Order in #{another_status} status. Only an order of :open status can be cancelled."}
  end
end
