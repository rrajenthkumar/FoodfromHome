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

  defp data(%Delivery{} = delivery) do
    %{
      id: delivery.id,
      distance_travelled_in_kms: delivery.distance_travelled_in_kms,
      picked_up_at: delivery.picked_up_at,
      delivered_at: delivery.delivered_at,
      current_position: delivery.current_position
    }
  end
end
