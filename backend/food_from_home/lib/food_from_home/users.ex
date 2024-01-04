defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  Interface to all User related methods for other contexts.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.SellerUserFromOrder
  alias FoodFromHome.Users.Services.CreateAuth0UserAndGetGeopositionAndCreateUserResource
  alias FoodFromHome.Users.Services.GetUpdatedGeopositionAndUpdateUser

  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_user(user_id), to: UserRepo
  defdelegate get_user_from_email!(email), to: UserRepo
  defdelegate update_user(user, attrs), to: UserRepo
  defdelegate soft_delete_user(user), to: UserRepo
  defdelegate delete_user(user), to: UserRepo

  def get_seller_user_from_order!(order), do: SellerUserFromOrder.get!(order)

  def create_auth0_user_and_get_geoposition_and_create_user_resource(attrs),
    do: CreateAuth0UserAndGetGeopositionAndCreateUserResource.call(attrs)

  def get_updated_geoposition_and_update_user(user, attrs),
    do: GetUpdatedGeopositionAndUpdateUser.call(user, attrs)
end
