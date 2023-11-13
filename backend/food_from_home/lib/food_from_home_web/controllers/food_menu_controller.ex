defmodule FoodFromHomeWeb.FoodMenuController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, params = %{}) do
    food_menus = FoodMenus.list_food_menus(params)
    render(conn, :index, food_menus: food_menus)
  end

  def create(conn, %{"food_menu" => food_menu_params, "seller_id" => seller_id}) do
    with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.create_food_menu(food_menu_params, seller_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/food-menus/#{food_menu.id}")
      |> render(:show, food_menu: food_menu)
    end
  end

  def show(conn, %{"menu_id" => menu_id}) do
    with %FoodMenu{} = food_menu <- FoodMenus.get_food_menu!(menu_id) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def update(conn, %{"food_menu" => food_menu_params, "menu_id" => menu_id}) do
    with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.update_food_menu(food_menu_params, menu_id) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def delete(conn, %{"menu_id" => menu_id}) do
    with {:ok, %FoodMenu{}} <- FoodMenus.delete_food_menu(menu_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
