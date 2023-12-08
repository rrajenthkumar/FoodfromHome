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

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{
        "seller_id" => seller_id,
        "seller" => seller_params
      }) do
    seller = Sellers.get!(seller_id)

    case seller_belongs_to_current_user?(current_user, seller) do
      true ->
        with {:ok, %Seller{} = seller} <- Sellers.update(seller, seller_params) do
          render(conn, :show, seller: seller)
        end

      false ->
        ErrorHandler.handle_error(conn, :forbidden, "Seller is not related to the current user")
    end
  end

  defp seller_belongs_to_current_user?(%User{id: current_user_id, user_type: :seller}, %Seller{
         seller_user_id: seller_user_id
       }) do
    seller_user_id === current_user_id
  end
end
