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

  def create(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id,
        "cart_item" => attrs
      }) do
    with {:ok, %Order{} = order} <-
           run_preliminary_checks(conn, order_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %CartItem{id: cart_item_id} = cart_item} <-
             CartItems.create_cart_item_and_update_food_menu_remaining_quantity(
               order,
               attrs
             ) do
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          ~p"/api/v1/orders/#{order_id}/cart_items/#{cart_item_id}"
        )
        |> render(:show, cart_item: cart_item)
      end
    end
  end

  def index(conn, %{"order_id" => order_id}) do
    with {:ok, %Order{} = order} <- run_preliminary_checks_for_index(conn, order_id) do
      cart_items = CartItems.list_cart_items_from_order(order)

      render(conn, :index, cart_items: cart_items)
    end
  end

  def show(conn, %{
        "order_id" => order_id,
        "cart_item_id" => cart_item_id
      }) do
    with {:ok, %CartItem{} = cart_item} <-
           run_preliminary_checks_for_show(conn, order_id, cart_item_id) do
      render(conn, :show, cart_item: cart_item)
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id,
        "cart_item_id" => cart_item_id,
        "cart_item" => attrs
      }) do
    with {:ok, %CartItem{} = cart_item} <- run_preliminary_checks(conn, order_id, cart_item_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %CartItem{} = cart_item} <-
             CartItems.update_cart_item_and_update_food_menu_remaining_quantity(
               cart_item,
               attrs
             ) do
        render(conn, :show, cart_item: cart_item)
      end
    end
  end

  def delete(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id,
        "cart_item_id" => cart_item_id
      }) do
    with {:ok, %CartItem{} = cart_item} <- run_preliminary_checks(conn, order_id, cart_item_id) do
      with {:ok, %CartItem{}} <- CartItems.delete_cart_item(cart_item) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  defp run_preliminary_checks(
         conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}},
         order_id,
         cart_item_id
       )
       when is_integer(order_id) and is_integer(cart_item_id) do
    order_result = Orders.get(order_id)

    cart_item_result = CartItems.get_cart_item(cart_item_id)

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      order_result.status != :open ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Order is in #{order_result.status} status. Only a cart item from an open order can be updated or deleted."
        )

      is_nil(cart_item_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Cart Item not found")

      true ->
        {:ok, cart_item_result}
    end
  end

  defp run_preliminary_checks(
         conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}},
         order_id
       )
       when is_integer(order_id) do
    order_result = Orders.get(order_id)

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      order_result.status != :open ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Order is in #{order_result.status} status. Cart item can be added only for an open order."
        )

      true ->
        {:ok, order_result}
    end
  end

  defp run_preliminary_checks_for_show(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         order_id,
         cart_item_id
       )
       when is_integer(order_id) and is_integer(cart_item_id) do
    order_result = Orders.get(order_id)

    cart_item_result = CartItems.get_cart_item(cart_item_id)

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      is_nil(cart_item_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Cart Item not found")

      true ->
        {:ok, cart_item_result}
    end
  end

  defp run_preliminary_checks_for_index(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         order_id
       )
       when is_integer(order_id) do
    order_result = Orders.get(order_id)

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
