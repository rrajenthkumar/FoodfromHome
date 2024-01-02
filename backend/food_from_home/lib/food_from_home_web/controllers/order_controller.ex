defmodule FoodFromHomeWeb.OrderController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn = %{assigns: %{current_user: %User{id: buyer_user_id}}}, %{"order" => attrs}) do
    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

    with {:ok, %Order{} = order} <- Orders.create_order(buyer_user_id, attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/orders/#{order.id}")
      |> render(:show, order: order)
    end
  end

  def index(conn = %{assigns: %{current_user: %User{} = current_user}}, _params) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    orders = Orders.list_order(current_user, filters)

    render(conn, :index, orders: orders)
  end

  def show(conn = %{assigns: %{current_user: %User{} = current_user}}, %{"order_id" => order_id}) do
    case Orders.get_order_with_associated_data(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            render(conn, :show, order: order)

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  # User type check is needed here as there is no user type check in router as every user can perform some kind of update based on his user type
  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"delivery_address" => delivery_address}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            delivery_address = Utils.convert_map_string_keys_to_atoms(delivery_address)

            with {:ok, %Order{} = order} <-
                   Orders.update_order_delivery_address(order, delivery_address) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"delivery_address" => _delivery_address}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a buyer user is permitted to update the delivery address"
    )
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"status" => :ready_for_pickup}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{} = order} <- Orders.mark_order_as_ready_for_pickup(order) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"status" => :ready_for_pickup}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a seller user is allowed to mark an order as ready for pickup"
    )
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"status" => :cancelled, "seller_remark" => seller_remark}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{} = order} <- Orders.cancel_order(order, seller_remark) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"status" => :cancelled}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a seller user is allowed to cancel an order"
    )
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"status" => :reserved_for_pickup}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{} = order} <- Orders.reserve_order_for_pickup(order, current_user) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"status" => :reserved_for_pickup}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a deliverer user is allowed to reserve an order for pickup"
    )
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"status" => :on_the_way}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{} = order} <- Orders.mark_order_as_on_the_way(order) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"status" => :on_the_way}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a deliverer user is allowed to mark an order as on the way"
    )
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{
        "order_id" => order_id,
        "order" => %{"status" => :delivered}
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{} = order} <- Orders.mark_order_as_delivered(order) do
              render(conn, :show, order: order)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{
        "order_id" => _order_id,
        "order" => %{"status" => :delivered}
      }) do
    ErrorHandler.handle_error(
      conn,
      :forbidden,
      "Only a deliverer user is allowed to mark an order as delivered"
    )
  end

  def delete(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{
        "order_id" => order_id
      }) do
    case Orders.get_order(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            with {:ok, %Order{}} <- Orders.delete_order(order) do
              send_resp(conn, :no_content, "")
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Order is not related to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end
end
