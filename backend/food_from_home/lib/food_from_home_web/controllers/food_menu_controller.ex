defmodule FoodFromHomeWeb.FoodMenuController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, params_with_filters = %{"seller_id" => _seller_id}) do
    food_menus = FoodMenus.list(params_with_filters)

    render(conn, :index, food_menus: food_menus)
  end

  def create(conn = %{assigns: %{current_user: current_user}}, %{"food_menu" => food_menu_params, "seller_id" => seller_id}) do
    food_menu_params = Utils.convert_map_string_keys_to_atoms(food_menu_params)

    case seller_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.create(seller_id, food_menu_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/v1/#{seller_id}/food-menus/#{food_menu.id}")
          |> render(:show, food_menu: food_menu)
        end
      false ->
        ErrorHandler.handle_error(conn, "403", "Seller id does not belong to the current user")
    end
  end

  def show(conn, %{"menu_id" => menu_id, "seller_id" => _seller_id}) do
    with %FoodMenu{} = food_menu <- FoodMenus.get!(menu_id) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def update(conn = %{assigns: %{current_user: current_user}}, %{"food_menu" => food_menu_params, "seller_id" => seller_id, "menu_id" => menu_id}) do
    food_menu_params = Utils.convert_map_string_keys_to_atoms(food_menu_params)

    case seller_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.update(menu_id, food_menu_params) do
          render(conn, :show, food_menu: food_menu)
        end
      false ->
        ErrorHandler.handle_error(conn, "403", "Seller id does not belong to the current user")
    end
  end

  def delete(conn = %{assigns: %{current_user: current_user}}, %{"seller_id" => seller_id, "menu_id" => menu_id}) do
    case seller_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{}} <- FoodMenus.delete(menu_id) do
          send_resp(conn, :no_content, "")
        end
      false ->
        ErrorHandler.handle_error(conn, "403", "Seller id does not belong to the current user")
    end
  end

  defp seller_belongs_to_current_user?(_current_user = %User{id: current_user_id}, seller_id) do
    %Seller{user_id: seller_user_id} = Sellers.get!(seller_id)
    seller_user_id === current_user_id
  end
end
