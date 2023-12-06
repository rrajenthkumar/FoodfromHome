defmodule FoodFromHome.Sellers.Finders.SellersWithUserInfo do
  @moduledoc """
  Lists sellers along with user info based on filters
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  def list(filters) when is_list(filters) do
    query =
      from seller in Seller,
        join: user in assoc(seller, :user),
        where: ^filters,
        preload: [user: user]

    Repo.all(query)
  end
end
