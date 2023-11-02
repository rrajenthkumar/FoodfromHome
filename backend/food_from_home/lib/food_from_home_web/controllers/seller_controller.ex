defmodule FoodFromHomeWeb.SellerController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, _params) do
    sellers = Sellers.list_sellers()
    render(conn, :index, sellers: sellers)
  end

  def create(conn, %{"seller" => seller_params}) do
    with {:ok, %Seller{} = seller} <- Sellers.create_seller(seller_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/sellers/#{seller}")
      |> render(:show, seller: seller)
    end
  end

  def show(conn, %{"id" => id}) do
    seller = Sellers.get_seller!(id)
    render(conn, :show, seller: seller)
  end

  def update(conn, %{"id" => id, "seller" => seller_params}) do
    seller = Sellers.get_seller!(id)

    with {:ok, %Seller{} = seller} <- Sellers.update_seller(seller, seller_params) do
      render(conn, :show, seller: seller)
    end
  end

  def delete(conn, %{"id" => id}) do
    seller = Sellers.get_seller!(id)

    with {:ok, %Seller{}} <- Sellers.delete_seller(seller) do
      send_resp(conn, :no_content, "")
    end
  end
end
