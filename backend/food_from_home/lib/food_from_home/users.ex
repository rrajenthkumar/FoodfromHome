defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.BuyerUserFromOrder
  alias FoodFromHome.Users.Finders.DelivererUserFromOrder
  alias FoodFromHome.Users.Finders.SellerUserFromOrder
  alias FoodFromHome.Users.Services.CreateUserWithGeoposition
  alias FoodFromHome.Users.Services.UpdateUserWithGeoposition

  defdelegate create_user(attrs), to: UserRepo
  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_user(user_id), to: UserRepo
  defdelegate update_user(user, attrs), to: UserRepo
  defdelegate soft_delete_user(user), to: UserRepo

  def create_user_with_geoposition(attrs), do: CreateUserWithGeoposition.call(attrs)
  def update_user_with_geoposition(user, attrs), do: UpdateUserWithGeoposition.call(user, attrs)
  def get_seller_user_from_order!(order), do: SellerUserFromOrder.get!(order)
end
