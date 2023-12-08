defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.BuyerUserFromOrder
  alias FoodFromHome.Users.Finders.DelivererUserFromOrder
  alias FoodFromHome.Users.Finders.SellerUserFromOrder

  defdelegate create(attrs), to: UserRepo
  defdelegate get!(user_id), to: UserRepo
  defdelegate get(user_id), to: UserRepo
  defdelegate update(user, attrs), to: UserRepo
  defdelegate soft_delete(user), to: UserRepo

  def find_buyer_user_from_order!(order), do: BuyerUserFromOrder.find!(order)
  def find_deliverer_user_from_order!(order), do: DelivererUserFromOrder.find!(order)
  def find_seller_user_from_order!(order), do: SellerUserFromOrder.find!(order)
end
