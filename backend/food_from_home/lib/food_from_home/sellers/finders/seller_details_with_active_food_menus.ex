defmodule FoodFromHome.Sellers.Finders.SellerDetailsWithActiveFoodMenus do
  @moduledoc """
  Gets a seller's details with a list of his active food menus in ascending order when he has active food menus. If he does not have an active menu an Ecto.NoResultsError error is returned.
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def find(seller_id) do
    query = from seller in Seller,
    join: food_menu in assoc(seller, :food_menus),
    where: seller.id == ^seller_id and food_menu.valid_until >= ^DateTime.utc_now(),
    order_by: [asc: food_menu.name],
    preload: [food_menus: food_menu]

    Repo.one!(query)
  end
end
