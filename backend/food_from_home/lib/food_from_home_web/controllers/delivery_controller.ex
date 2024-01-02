defmodule FoodFromHomeWeb.DeliveryController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler
  alias FoodFromHomeWeb.Utils, as: FoodFromHomeWebUtils

  action_fallback FoodFromHomeWeb.FallbackController

  @allowed_update_attrs [:current_geoposition, :distance_travelled_in_kms]

  def index(conn = %{assigns: %{current_user: %User{} = current_seller_or_deliverer_user}}) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    deliveries = Deliveries.list_deliveries_from_user(current_seller_or_deliverer_user, filters)

    render(conn, :index, deliveries: deliveries)
  end

  def show(conn = %{assigns: %{current_user: %User{} = _current_seller_or_deliverer_user}}, %{
        "order_id" => order_id
      }) do
    with {:ok, %Order{} = order} <-
           run_preliminary_checks(conn, order_id) do
      delivery = Deliveries.get_delivery_from_order!(order)

      render(conn, :show, delivery: delivery)
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer}}}, %{
        "order_id" => order_id,
        "delivery" => attrs
      }) do
    with {:ok, %Order{} = order} <-
           run_preliminary_checks(conn, order_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, attrs} <-
             FoodFromHomeWebUtils.unallowed_attributes_check(
               conn,
               attrs,
               @allowed_update_attrs
             ) do
        delivery = Deliveries.get_delivery_from_order!(order)

        with {:ok, %Delivery{} = delivery} <-
               Deliveries.update_delivery(delivery, attrs) do
          render(conn, :show, delivery: delivery)
        end
      end
    end
  end

  defp run_preliminary_checks(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         order_id
       )
       when is_integer(order_id) do
    order_result = Orders.get_order(order_id)

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      true ->
        {:ok, order_result}
    end
  end
end
