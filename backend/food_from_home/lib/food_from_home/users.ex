defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.BuyerUserFromOrder
  alias FoodFromHome.Users.Finders.DelivererUserFromOrder
  alias FoodFromHome.Users.Finders.SellerUserFromOrder

  defdelegate create_user(attrs), to: UserRepo
  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_user(user_id), to: UserRepo
  defdelegate update_user(user, attrs), to: UserRepo
  defdelegate soft_delete_user(user), to: UserRepo

  def find_seller_user_from_order!(order), do: SellerUserFromOrder.find!(order)
end
