defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Sellers context.
  """
  alias FoodFromHome.Sellers.SellerRepo

  defdelegate create_seller(user_id, attrs), to: SellerRepo
  defdelegate get_seller!(seller_id), to: SellerRepo
  defdelegate update_seller(seller_id, attrs), to: SellerRepo #Used by API route
end
