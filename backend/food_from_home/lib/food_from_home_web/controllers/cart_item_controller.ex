defmodule FoodFromHomeWeb.CartItemController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.CartItems
  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{"order_id" => order_id, "cart_item" => attrs}) do
    case Orders.get(order_id) do
      %Order{status: order_status} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case order_status do
              :open ->
                attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                with {:ok, %CartItem{id: cart_item_id} = cart_item} <- CartItems.create(order, attrs) do
                  conn
                  |> put_status(:created)
                  |> put_resp_header("location", ~p"/api/v1/orders/#{order_id}/cart_items/#{cart_item_id}")
                  |> render(:show, cart_item: cart_item)
                end
              another_status ->
                ErrorHandler.handle_error(conn, "403", "Order is in #{another_status} status. Cart item can be added only for an open order.")
            end
          false -> ErrorHandler.handle_error(conn, "403", "Order not related to the user")
        end
      nil -> ErrorHandler.handle_error(conn, "404", "Order not found")
    end
  end

  def index(conn = %{assigns: %{current_user: %User{} = current_user}}, %{"order_id" => order_id}) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            cart_items = CartItems.list_cart_items_from_order(order)

            render(conn, :index, cart_items: cart_items)
          false -> ErrorHandler.handle_error(conn, "403", "Order not related to the user")
        end
      nil -> ErrorHandler.handle_error(conn, "404", "Order not found")
    end
  end

  def show(conn = %{assigns: %{current_user: %User{} = current_user}}, %{"order_id" => order_id, "cart_item_id" => cart_item_id}) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case CartItems.get(cart_item_id) do
              %CartItem{} = cart_item ->
                render(conn, :show, cart_item: cart_item)
              nil ->
                ErrorHandler.handle_error(conn, "404", "Cart item not found")
            end
          false -> ErrorHandler.handle_error(conn, "403", "Order not related to the user")
        end
      nil -> ErrorHandler.handle_error(conn, "404", "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{"order_id" => order_id, "cart_item_id" => cart_item_id, "cart_item" => attrs}) do
    case Orders.get(order_id) do
      %Order{status: order_status} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case order_status do
              :open ->
                case CartItems.get(cart_item_id) do
                  %CartItem{} = cart_item ->
                    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                    with {:ok, %CartItem{} = cart_item} <- CartItems.update(cart_item, attrs) do
                      render(conn, :show, cart_item: cart_item)
                    end
                  nil ->
                    ErrorHandler.handle_error(conn, "404", "Cart item not found")
                end
              another_status ->
                ErrorHandler.handle_error(conn, "403", "Order is in #{another_status} status. Cart item can be updated only for an open order.")
            end
          false -> ErrorHandler.handle_error(conn, "403", "Order not related to the user")
        end
      nil -> ErrorHandler.handle_error(conn, "404", "Order not found")
    end
  end

  def delete(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{"order_id" => order_id, "cart_item_id" => cart_item_id}) do
    case Orders.get(order_id) do
      %Order{status: order_status} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case order_status do
              :open ->
                case CartItems.get(cart_item_id) do
                  %CartItem{} = cart_item ->
                    with {:ok, %CartItem{}} <- CartItems.delete(cart_item) do
                      send_resp(conn, :no_content, "")
                    end
                  nil ->
                    ErrorHandler.handle_error(conn, "404", "Cart item not found")
                end
              another_status ->
                ErrorHandler.handle_error(conn, "403", "Order is in #{another_status} status. Cart item can be deleted only for an open order.")
            end
          false -> ErrorHandler.handle_error(conn, "403", "Order not related to the user")
        end
      nil -> ErrorHandler.handle_error(conn, "404", "Order not found")
    end
  end
end
