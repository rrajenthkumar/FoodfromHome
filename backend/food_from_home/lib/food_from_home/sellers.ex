defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Sellers context.
  """
  alias FoodFromHome.Sellers.Finders.SellerFromUser
  alias FoodFromHome.Sellers.Finders.SellersWithUserInfo
  alias FoodFromHome.Sellers.Finders.SellerWithUserInfoAndActiveMenus
  alias FoodFromHome.Sellers.SellerRepo

  defdelegate get(seller_id), to: SellerRepo
  defdelegate get!(seller_id), to: SellerRepo
  defdelegate update(seller, attrs), to: SellerRepo

  def list(filters), do: SellersWithUserInfo.list(filters)

  def get_with_user_info_and_active_menus!(seller_id),
    do: SellerWithUserInfoAndActiveMenus.find!(seller_id)

  def find_seller_from_user!(user), do: SellerFromUser.find!(user)
end
