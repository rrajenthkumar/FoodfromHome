defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Seller context.
  Interface to all Seller related methods for other contexts.
  """
  alias FoodFromHome.Sellers.Finders.SellersWithUserInfo
  alias FoodFromHome.Sellers.Finders.SellerFromUser
  alias FoodFromHome.Sellers.Finders.SellerWithUserInfoAndAvailableMenus
  alias FoodFromHome.Sellers.SellerRepo

  defdelegate get_seller(seller_id), to: SellerRepo
  defdelegate get_seller!(seller_id), to: SellerRepo

  def list_sellers_with_user_info(filters), do: SellersWithUserInfo.list(filters)

  def get_seller_with_user_info_and_available_menus(seller_id),
    do: SellerWithUserInfoAndAvailableMenus.get(seller_id)

  def get_seller_from_user!(user), do: SellerFromUser.get!(user)
end
