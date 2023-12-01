defmodule FoodFromHomeWeb.OrderController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers
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
      |> put_resp_header("location", ~p"/api/v1/api/orders/#{order.id}")
      |> render(:show, order: order)
    end
  end

  def index(conn = %{assigns: %{current_user: current_user}}) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

      orders = Orders.list(current_user, filters)

      render(conn, :index, orders: orders)
  end

  def show(conn = %{assigns: %{current_user: current_user}}, %{"order_id" => order_id}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          render(conn, :show, order: order, related_users: get_seller_buyer_deliverer_users(order))
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
  end

  defp get_seller_buyer_deliverer_users(order = %Order{status: :open}) do
    seller_user = Users.SellerUserFromOrder.find!(order)
    buyer_user = Users.BuyerUserFromOrder.find!(order)

    {seller_user, buyer_user, nil}
  end

  defp get_seller_buyer_deliverer_users(order = %Order{status: :confirmed}) do
    seller_user = Users.SellerUserFromOrder.find!(order)
    buyer_user = Users.BuyerUserFromOrder.find!(order)

    {seller_user, buyer_user, nil}
  end

  defp get_seller_buyer_deliverer_users(order = %Order{status: :cancelled}) do
    seller_user = Users.SellerUserFromOrder.find!(order)
    buyer_user = Users.BuyerUserFromOrder.find!(order)

    {seller_user, buyer_user, nil}
  end

  defp get_seller_buyer_deliverer_users(order = %Order{status: :ready_for_delivery}) do
    seller_user = Users.SellerUserFromOrder.find!(order)
    buyer_user = Users.BuyerUserFromOrder.find!(order)

    {seller_user, buyer_user, nil}
  end

  defp get_seller_buyer_deliverer_users(order = %Order{}) do
    seller_user = Users.SellerUserFromOrder.find!(order)
    buyer_user = Users.BuyerUserFromOrder.find!(order)
    deliverer_user = Users.DelivererUserFromOrder.find!(order)

    {seller_user, buyer_user, deliverer_user}
  end

  def update(conn = %{assigns: %{current_user: current_user}}, %{"order_id" => order_id, "order" => attrs}) do
    with %Order{} = order <- Orders.get!(order_id) do
      case order_related_to_current_user?(current_user, order) do
        true ->
          allowed_fields = allowed_fields(current_user)

          {allowed_attrs, other_attrs} = Map.split(attrs, allowed_fields)

          case Enum.empty?(other_attrs) do
            true ->
              attrs = Utils.convert_map_string_keys_to_atoms(allowed_attrs)

              case valid_status_attr?(current_user, attrs) do
                true ->
                  with {:ok, %Order{} = order} <- Orders.update(order, attrs) do
                    render(conn, :show, order: order)
                  end
                false ->
                  ErrorHandler.handle_error(conn, "403", "Status change not permitted for the user")
              end
            false ->
              ErrorHandler.handle_error(conn, "403", "Not permitted attributes found in request")
          end
        false ->
          ErrorHandler.handle_error(conn, "403", "Order is not related to the current user")
      end
    end
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

  defp allowed_fields(current_user = %User{user_type: :seller}), do: [:status, :seller_remark]

  defp allowed_fields(current_user = %User{user_type: :buyer}), do: [:delivery_address]

  defp allowed_fields(current_user = %User{user_type: :deliverer}), do: [:status]

  defp valid_status_attr?(current_user = %User{user_type: :seller}, _attrs = %{status: status}), do: Enum.member?([:ready_for_pickup, :cancelled], status)

  defp valid_status_attr?(current_user = %User{user_type: :deliverer}, _attrs = %{status: status}), do: Enum.member?([:reserved_for_pickup, :on_the_way, :delivered], status)

  defp valid_status_attr?(current_user = %User{}, _attrs = %{}), do: true
end
