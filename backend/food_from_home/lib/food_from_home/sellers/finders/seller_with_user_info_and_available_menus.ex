defmodule FoodFromHome.Sellers.Finders.SellerWithUserInfoAndAvailableMenus do
  @moduledoc """
  Finder to get a seller along with user details and available (vaild & remaining_quantity > 0) food menus
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def get(seller_id) when is_integer(seller_id) do
    query =
      from seller in Seller,
        join: seller_user in assoc(seller, :seller_user),
        join: food_menu in assoc(seller, :food_menus),
        where: seller.id == ^seller_id,
        preload: [
          seller_user: seller_user,
          food_menus:
            ^from(food_menu in FoodMenu,
              where:
                food_menu.valid_until >= ^DateTime.utc_now() and food_menu.remaining_quantity > 0
            )
        ]

    Repo.one(query)
  end
end
