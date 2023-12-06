defmodule FoodFromHome.Orders.Services.SetCancelledStatusAndAddSellerRemarkAndProduceOrderCancelledEvent do
    @moduledoc """
    Used by seller to change the status of an open order to :cancelled in case of some difficulty in honouring the order, add seller remark, and produce an order_cancelled Kafka event to be consumed by the notification module.
    """
    alias FoodFromHome.Orders
    alias FoodFromHome.Orders.Order

    def call(order = %Order{status: :open}, seller_remark) do
      case Orders.update(order, %{status: :cancelled, seller_remark: seller_remark}) do
        {:ok, %Order{}} = result ->
          # produce_order_cancelled_event()
          result
        error ->
          error
      end
    end

    def call(%Order{status: another_status}, _seller_remark) do
      {:error, 403, "Order in #{another_status} status. Only an order of :open status can be cancelled"}
    end
end
