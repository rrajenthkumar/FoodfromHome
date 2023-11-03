defmodule FoodFromHomeWeb.DeliveryController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, _params) do
    deliveries = Deliveries.list_deliveries()
    render(conn, :index, deliveries: deliveries)
  end

  def create(conn, %{"delivery" => delivery_params}) do
    with {:ok, %Delivery{} = delivery} <- Deliveries.create_delivery(delivery_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/deliveries/#{delivery}")
      |> render(:show, delivery: delivery)
    end
  end

  def show(conn, %{"id" => id}) do
    delivery = Deliveries.get_delivery!(id)
    render(conn, :show, delivery: delivery)
  end

  def update(conn, %{"id" => id, "delivery" => delivery_params}) do
    delivery = Deliveries.get_delivery!(id)

    with {:ok, %Delivery{} = delivery} <- Deliveries.update_delivery(delivery, delivery_params) do
      render(conn, :show, delivery: delivery)
    end
  end

  def delete(conn, %{"id" => id}) do
    delivery = Deliveries.get_delivery!(id)

    with {:ok, %Delivery{}} <- Deliveries.delete_delivery(delivery) do
      send_resp(conn, :no_content, "")
    end
  end
end
