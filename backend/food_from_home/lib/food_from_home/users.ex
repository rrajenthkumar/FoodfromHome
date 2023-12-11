defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  Interface to all User related methods for other contexts.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.SellerUserFromOrder
  alias FoodFromHome.Users.Services.GetGeopositionAndCreateUser
  alias FoodFromHome.Users.Services.GetUpdatedGeopositionAndUpdateUser

  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_user(user_id), to: UserRepo
  defdelegate update_user(user, attrs), to: UserRepo
  defdelegate soft_delete_user(user), to: UserRepo

  def get_geoposition_and_create_user(attrs), do: GetGeopositionAndCreateUser.call(attrs)

  def get_updated_geoposition_and_update_user(user, attrs),
    do: GetUpdatedGeopositionAndUpdateUser.call(user, attrs)

  def get_seller_user_from_order!(order), do: SellerUserFromOrder.get!(order)
end
