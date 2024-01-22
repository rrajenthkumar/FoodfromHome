defmodule FoodFromHome.Sellers.Finders.SellersWithUserInfo do
  @moduledoc """
  Finder to list sellers along with user info based on filters
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def list(filters) when is_list(filters) do
    query =
      from seller in Seller,
        join: seller_user in assoc(seller, :seller_user),
        where: ^filters,
        preload: [seller_user: seller_user]

    Repo.all(query)
  end
end
