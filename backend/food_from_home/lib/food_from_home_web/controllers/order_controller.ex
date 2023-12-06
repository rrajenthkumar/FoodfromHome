defmodule FoodFromHomeWeb.OrderController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Deliveries
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn = %{assigns: %{current_user: %User{id: buyer_user_id}}}, %{"order" => attrs}) do
    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

    with {:ok, %Order{} = order} <- Orders.create(buyer_user_id, attrs) do
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

      orders = Orders.list(current_user, filters)

      render(conn, :index, orders: orders)
  end

  def show(conn = %{assigns: %{current_user: %User{} = current_user}}, %{"order_id" => order_id}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          render(conn, :show, order: order, related_users: get_related_users(order))
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{"order_id" => order_id, "order" => %{"delivery_address" => delivery_address}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          delivery_address = Utils.convert_map_string_keys_to_atoms(delivery_address)

          with {:ok, %Order{} = order} <- Orders.update_delivery_address(order, delivery_address) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"delivery_address" => _delivery_address}}) do
    ErrorHandler.handle_error(conn, "403", "Only a buyer user is permitted to update the delivery address")
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{"order_id" => order_id, "order" => %{"status" => :ready_for_pickup}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          with {:ok, %Order{} = order} <- Orders.mark_as_ready_for_pickup(order) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"status" => :ready_for_pickup}}) do
    ErrorHandler.handle_error(conn, "403", "Only a seller user is allowed to mark an order as ready for pickup")
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{"order_id" => order_id, "order" => %{"status" => :cancelled, "seller_remark" => seller_remark}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          with {:ok, %Order{} = order} <- Orders.cancel(order, seller_remark) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"status" => :cancelled}}) do
    ErrorHandler.handle_error(conn, "403", "Only a seller user is allowed to cancel an order")
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{"order_id" => order_id, "order" => %{"status" => :reserved_for_pickup}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          with {:ok, %Order{} = order} <- Orders.reserve_for_pickup(order, current_user) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"status" => :reserved_for_pickup}}) do
    ErrorHandler.handle_error(conn, "403", "Only a deliverer user is allowed to reserve an order for pickup")
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{"order_id" => order_id, "order" => %{"status" => :on_the_way}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          with {:ok, %Order{} = order} <- Orders.mark_as_on_the_way(order) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"status" => :on_the_way}}) do
    ErrorHandler.handle_error(conn, "403", "Only a deliverer user is allowed to mark an order as on the way")
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :deliverer} = current_user}}, %{"order_id" => order_id, "order" => %{"status" => :delivered}}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          with {:ok, %Order{} = order} <- Orders.mark_as_delivered(order) do
            render(conn, :show, order: order)
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: _another_type}}}, %{"order_id" => _order_id, "order" => %{"status" => :delivered}}) do
    ErrorHandler.handle_error(conn, "403", "Only a deliverer user is allowed to mark an order as delivered")
  end

  defp order_related_to_current_user?(current_user = %User{user_type: :seller}, %Order{seller_id: seller_id}) do
    %Seller{id: current_user_seller_id} = Sellers.find_seller_from_user!(current_user)
    seller_id === current_user_seller_id
  end

  defp order_related_to_current_user?(%User{id: current_user_id, user_type: :buyer}, %Order{buyer_user_id: buyer_user_id}) do
    buyer_user_id === current_user_id
  end

  defp order_related_to_current_user?(%User{id: current_user_id, user_type: :deliverer}, order = %Order{}) do
    %Delivery{deliverer_user_id: deliverer_user_id} = Deliveries.find_delivery_from_order!(order)
    deliverer_user_id === current_user_id
  end

  defp get_related_users(order = %Order{status: status}) when status in [:open, :confirmed, :cancelled, :ready_for_delivery]do
    seller_user = Users.find_seller_user_from_order!(order)
    buyer_user = Users.find_buyer_user_from_order!(order)

    {seller_user, buyer_user, nil}
  end

  defp get_related_users(order = %Order{}) do
    seller_user = Users.find_seller_user_from_order!(order)
    buyer_user = Users.find_buyer_user_from_order!(order)
    deliverer_user = Users.find_deliverer_user_from_order!(order)

    {seller_user, buyer_user, deliverer_user}
  end
end
