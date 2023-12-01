defmodule FoodFromHome.Sellers do
  @moduledoc """
  The Sellers context.
  """
  alias FoodFromHome.Sellers.Finders.SellerFromUser
  alias FoodFromHome.Sellers.SellerRepo

  defdelegate list(filter_params), to: SellerRepo

  def find_seller_from_user!(user), do: SellerFromUser.find!(user)
end
