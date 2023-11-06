defmodule FoodFromHomeWeb.FoodMenuController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, %{"seller_id" => seller_id}) do
    food_menus = FoodMenus.list_active_food_menus_from_seller(seller_id)
    render(conn, :index, food_menus: food_menus)
  end

  def create(conn, %{"food_menu" => food_menu_params}) do
    with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.create_food_menu(food_menu_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/food_menus/#{food_menu}")
      |> render(:show, food_menu: food_menu)
    end
  end

  def show(conn, %{"menu_id" => menu_id}) do
    food_menu = FoodMenus.get_food_menu!(menu_id)
    render(conn, :show, food_menu: food_menu)
  end

  def update(conn, %{"menu_id" => menu_id, "food_menu" => food_menu_params}) do
    with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.update_food_menu(menu_id, food_menu_params) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def delete(conn, %{"menu_id" => menu_id}) do
    with {:ok, %FoodMenu{}} <- FoodMenus.delete_food_menu(menu_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
