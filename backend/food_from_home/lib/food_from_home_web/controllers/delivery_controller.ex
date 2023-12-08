defmodule FoodFromHomeWeb.DeliveryController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn = %{assigns: %{current_user: %User{} = current_seller_or_deliverer_user}}) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    deliveries = Deliveries.list_deliveries_from_user(current_seller_or_deliverer_user, filters)

    render(conn, :index, deliveries: deliveries)
  end

  def show(conn = %{assigns: %{current_user: %User{} = current_seller_or_deliverer_user}}, %{
        "order_id" => order_id
      }) do
    delivery = Deliveries.get_with_order_id!(order_id)

    case delivery_related_to_current_user?(current_seller_or_deliverer_user, delivery) do
      true ->
        render(conn, :show, delivery: delivery)

      false ->
        ErrorHandler.handle_error(conn, "403", "Delivery is not related to the current user")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{
        "order_id" => order_id,
        "delivery" => delivery_params
      }) do
    delivery = Deliveries.get_with_order_id!(order_id)

    case delivery_related_to_current_user?(current_user, delivery) do
      true ->
        with {:ok, %Order{} = delivery} <- Deliveries.update(delivery, delivery_params) do
          render(conn, :show, delivery: delivery)
        end

      false ->
        ErrorHandler.handle_error(conn, "403", "Delivery is not related to the current user")
    end
  end

  defp delivery_related_to_current_user?(
         %User{id: current_user_id, user_type: :deliverer},
         %Delivery{deliverer_user_id: deliverer_user_id}
       ) do
    deliverer_user_id === current_user_id
  end

  defp delivery_related_to_current_user?(
         %User{id: current_user_id, user_type: :seller},
         %Delivery{order_id: order_id}
       ) do
    %User{id: seller_user_id} =
      order_id
      |> Orders.get!()
      |> Users.find_seller_user_from_order!()

    seller_user_id === current_user_id
  end
end
