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
    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

    case seller_id_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.create(seller_id, attrs) do
          conn
          |> put_status(:created)
          |> put_resp_header(
            "location",
            ~p"/api/v1/sellers/#{seller_id}/food-menus/#{food_menu.id}"
          )
          |> render(:show, food_menu: food_menu)
        end

      false ->
        ErrorHandler.handle_error(conn, :forbidden, "Seller id does not belong to the current user")
    end
  end

  def index(conn, %{"seller_id" => seller_id}) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    food_menus = FoodMenus.list(seller_id, filters)

    render(conn, :index, food_menus: food_menus)
  end

  def show(conn, %{"food_menu_id" => food_menu_id}) do
    with %FoodMenu{} = food_menu <- FoodMenus.get!(food_menu_id) do
      render(conn, :show, food_menu: food_menu)
    end
  end

  def update(conn = %{assigns: %{current_user: current_user}}, %{
        "food_menu" => attrs,
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

    case seller_id_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{} = food_menu} <- FoodMenus.update(food_menu_id, attrs) do
          render(conn, :show, food_menu: food_menu)
        end

      false ->
        ErrorHandler.handle_error(conn, :forbidden, "Seller id does not belong to the current user")
    end
  end

  def delete(conn = %{assigns: %{current_user: current_user}}, %{
        "seller_id" => seller_id,
        "food_menu_id" => food_menu_id
      }) do
    case seller_id_belongs_to_current_user?(current_user, seller_id) do
      true ->
        with {:ok, %FoodMenu{}} <- FoodMenus.delete(food_menu_id) do
          send_resp(conn, :no_content, "")
        end

      false ->
        ErrorHandler.handle_error(conn, :forbidden, "Seller id does not belong to the current user")
    end
  end

  defp seller_id_belongs_to_current_user?(_current_user = %User{id: current_user_id}, seller_id) do
    %Seller{seller_user_id: seller_user_id} = Sellers.get!(seller_id)
    seller_user_id === current_user_id
  end
end
