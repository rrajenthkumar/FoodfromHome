defmodule FoodFromHomeWeb.FoodMenuController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn, %{
        "food_menu" => attrs,
        "seller_id" => seller_id
      }) do
    with {:ok, %Seller{} = seller} <- preliminary_check_result(conn, seller_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.create_food_menu(seller, attrs) do
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          ~p"/api/v1/sellers/#{seller_id}/food-menus/#{food_menu.id}"
        )
        |> render(:show, food_menu: food_menu)
      end
    end
  end

  def index(conn, %{
        "seller_id" => seller_id
      }) do
    with {:ok, %Seller{} = seller} <- preliminary_check_result(conn, seller_id) do
      filters =
        conn
        |> fetch_query_params()
        |> Utils.convert_map_to_keyword_list()

      food_menus = FoodMenus.list_food_menu(seller, filters)

      render(conn, :index, food_menus: food_menus)
    end
  end

  def show(conn, %{
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    with {:ok, %FoodMenu{} = food_menu} <- preliminary_check_result(conn, seller_id, food_menu_id) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def update(conn, %{
        "food_menu" => attrs,
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    with {:ok, %FoodMenu{} = food_menu} <- preliminary_check_result(conn, seller_id, food_menu_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %FoodMenu{} = food_menu} <-
             FoodMenus.update_food_menu(food_menu, attrs) do
        render(conn, :show, food_menu: food_menu)
      end
    end
  end

  def delete(conn, %{
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    with {:ok, %FoodMenu{} = food_menu} <- preliminary_check_result(conn, seller_id, food_menu_id) do
      with {:ok, %FoodMenu{}} <- FoodMenus.delete_food_menu(food_menu) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  defp preliminary_check_result(
         conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}},
         seller_id
       )
       when is_integer(seller_id) do
    seller_result = Sellers.get_seller(seller_id)

    cond do
      is_nil(seller_result) ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )

      seller_does_not_belong_to_current_user?(current_user, seller_result) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Seller does not belong to the current user"
        )

      true ->
        {:ok, seller_result}
    end
  end

  defp preliminary_check_result(
         conn = %{assigns: %{current_user: %User{user_type: :buyer}}},
         seller_id,
         food_menu_id
       )
       when is_integer(seller_id) and is_integer(food_menu_id) do
    seller_result = Sellers.get_seller(seller_id)

    food_menu_result = FoodMenus.get_food_menu(food_menu_id)

    cond do
      is_nil(seller_result) ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )

      is_nil(food_menu_result) ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Food menu not found"
        )

      food_menu_does_not_belong_to_seller?(seller_result, food_menu_result) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Food menu does not belong to the seller"
        )

      true ->
        {:ok, food_menu_result}
    end
  end

  defp preliminary_check_result(
         conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}},
         seller_id,
         food_menu_id
       )
       when is_integer(seller_id) and is_integer(food_menu_id) do
    seller_result = Sellers.get_seller(seller_id)

    food_menu_result = FoodMenus.get_food_menu(food_menu_id)

    cond do
      is_nil(seller_result) ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )

      seller_does_not_belong_to_current_user?(current_user, seller_result) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Seller does not belong to the current user"
        )

      is_nil(food_menu_result) ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Food menu not found"
        )

      food_menu_does_not_belong_to_seller?(seller_result, food_menu_result) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Food menu does not belong to the seller"
        )

      true ->
        {:ok, food_menu_result}
    end
  end

  defp seller_does_not_belong_to_current_user?(%User{id: current_user_id}, %Seller{
         seller_user_id: seller_user_id
       }) do
    current_user_id !== seller_user_id
  end

  defp food_menu_does_not_belong_to_seller?(%Seller{id: seller_id}, %FoodMenu{
         seller_id: food_menu_seller_id
       }) do
    seller_id !== food_menu_seller_id
  end
end
