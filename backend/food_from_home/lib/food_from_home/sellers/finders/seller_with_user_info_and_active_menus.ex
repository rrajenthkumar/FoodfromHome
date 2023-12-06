defmodule FoodFromHome.Sellers.Finders.SellerWithUserInfoAndActiveMenus do
  @moduledoc """
  Gets a seller along with user details and active (valid_until >= now), available (remaining_quantity > 0) food menus
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def find!(seller_id) when is_integer(seller_id) do
    query =
      from seller in Seller,
        join: user in assoc(seller, :seller_user),
        join: food_menu in assoc(seller, :food_menus),
        where: seller.id == ^seller_id,
        preload: [user: user, food_menus: ^from(food_menu in FoodMenu, where: food_menu.valid_until >= ^DateTime.utc_now() and food_menu.remaining_quantity > 0)]

    Repo.one!(query)
  end
end
