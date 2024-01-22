defmodule FoodFromHomeWeb.SellerController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, _params) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    sellers = Sellers.list_sellers_with_user_info(filters)

    render(conn, :index, sellers: sellers)
  end

  def show(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "seller_id" => seller_id
      }) do
    case Sellers.get_seller_with_user_info_and_available_menus(seller_id) do
      %Seller{} = seller ->
        render(conn, :show, seller: seller)

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Seller not found")
    end
  end
end
