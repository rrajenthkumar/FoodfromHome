defmodule FoodFromHomeWeb.FoodMenuController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, _params) do
    food_menus = FoodMenus.list_food_menus()
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

  def show(conn, %{"id" => id}) do
    food_menu = FoodMenus.get_food_menu!(id)
    render(conn, :show, food_menu: food_menu)
  end

  def update(conn, %{"id" => id, "food_menu" => food_menu_params}) do
    food_menu = FoodMenus.get_food_menu!(id)

    with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.update_food_menu(food_menu, food_menu_params) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def delete(conn, %{"id" => id}) do
    food_menu = FoodMenus.get_food_menu!(id)

    with {:ok, %FoodMenu{}} <- FoodMenus.delete_food_menu(food_menu) do
      send_resp(conn, :no_content, "")
    end
  end
end
