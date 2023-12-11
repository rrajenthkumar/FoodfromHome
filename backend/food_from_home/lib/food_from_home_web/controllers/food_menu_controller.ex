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

  def create(conn = %{assigns: %{current_user: current_user}}, %{
        "food_menu" => attrs,
        "seller_id" => seller_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case seller_belongs_to_current_user?(current_user, seller) do
          true ->
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

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Seller does not belong to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )
    end
  end

  def index(conn = %{assigns: %{current_user: current_user}}, %{"seller_id" => seller_id}) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case seller_belongs_to_current_user?(current_user, seller) do
          true ->
            filters =
              conn
              |> fetch_query_params()
              |> Utils.convert_map_to_keyword_list()

            food_menus = FoodMenus.list_food_menu(seller, filters)

            render(conn, :index, food_menus: food_menus)

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Seller does not belong to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )
    end
  end

  def show(conn = %{assigns: %{current_user: current_user}}, %{
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case seller_belongs_to_current_user?(current_user, seller) do
          true ->
            with %FoodMenu{} = food_menu <- FoodMenus.get_food_menu!(food_menu_id) do
              render(conn, :show, food_menu: food_menu)
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Seller does not belong to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )
    end
  end

  def update(conn = %{assigns: %{current_user: current_user}}, %{
        "food_menu" => attrs,
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case seller_belongs_to_current_user?(current_user, seller) do
          true ->
            case FoodMenus.get_food_menu(food_menu_id) do
              %FoodMenu{} = food_menu ->
                attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                with {:ok, %FoodMenu{} = food_menu} <-
                       FoodMenus.update_food_menu(food_menu, attrs) do
                  render(conn, :show, food_menu: food_menu)
                end

              nil ->
                ErrorHandler.handle_error(
                  conn,
                  :not_found,
                  "Food menu not found"
                )
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Seller does not belong to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )
    end
  end

  def delete(conn = %{assigns: %{current_user: current_user}}, %{
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case seller_belongs_to_current_user?(current_user, seller) do
          true ->
            case FoodMenus.get_food_menu(food_menu_id) do
              %FoodMenu{} = food_menu ->
                with {:ok, %FoodMenu{}} <- FoodMenus.delete_food_menu(food_menu) do
                  send_resp(conn, :no_content, "")
                end

              nil ->
                ErrorHandler.handle_error(
                  conn,
                  :not_found,
                  "Food menu not found"
                )
            end

          false ->
            ErrorHandler.handle_error(
              conn,
              :forbidden,
              "Seller does not belong to the current user"
            )
        end

      nil ->
        ErrorHandler.handle_error(
          conn,
          :not_found,
          "Seller not found"
        )
    end
  end

  defp seller_belongs_to_current_user?(%User{id: current_user_id}, %Seller{
         seller_user_id: seller_user_id
       }) do
    seller_user_id === current_user_id
  end
end
