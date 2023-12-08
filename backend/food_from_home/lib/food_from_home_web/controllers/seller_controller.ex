defmodule FoodFromHomeWeb.SellerController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, _params) do
    filters =
      conn
      |> fetch_query_params()
      |> Utils.convert_map_to_keyword_list()

    sellers = Sellers.list(filters)
    render(conn, :index, sellers: sellers)
  end

  def show(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "seller_id" => seller_id
      }) do
    with {:ok, %Seller{} = seller} <- Sellers.get_with_user_info_and_active_menus!(seller_id) do
      render(conn, :show, seller: seller)
    end
  end
end
