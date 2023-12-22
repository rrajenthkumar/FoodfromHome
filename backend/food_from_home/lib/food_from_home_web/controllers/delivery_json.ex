defmodule FoodFromHomeWeb.DeliveryJSON do
  alias FoodFromHome.Deliveries.Delivery

  @doc """
  Renders a list of deliveries.
  """
  def index(%{deliveries: deliveries}) do
    %{data: for(delivery <- deliveries, do: data(delivery))}
  end

  @doc """
  Renders a single delivery.
  """
  def show(%{delivery: delivery}) do
    %{data: data(delivery)}
  end

  defp data(delivery = %Delivery{}) do
    %{
      id: delivery.id,
      order_id: delivery.order_id,
      picked_up_at: delivery.picked_up_at,
      current_geoposition: delivery.current_geoposition,
      distance_travelled_in_kms: delivery.distance_travelled_in_kms,
      delivered_at: delivery.delivered_at,
      deliverer_user_id: delivery.deliverer_user_id
    }
  end
end
