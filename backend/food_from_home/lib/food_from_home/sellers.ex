defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Sellers context.
  """
  alias FoodFromHome.Sellers.SellerRepo

  defdelegate get_seller!(seller_id), to: SellerRepo
  defdelegate update_seller(seller_id, attrs), to: SellerRepo
end
