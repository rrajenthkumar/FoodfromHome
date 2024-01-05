defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  Interface to all User related methods.
  """
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.Finders.SellerUserFromOrder
  alias FoodFromHome.Users.Services.CreateAuth0UserAndGetGeopositionAndCreateUser
  alias FoodFromHome.Users.Services.DeleteAuth0UserAndSoftDeleteUser
  alias FoodFromHome.Users.Services.GetUpdatedGeopositionAndUpdateUser
  alias FoodFromHome.Users.Services.UpdateEmailInAuth0UserAndUser
  alias FoodFromHome.Users.Services.UpdatePasswordInAuth0User

  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_user(user_id), to: UserRepo
  defdelegate get_user_from_email(email), to: UserRepo
  defdelegate update_user(user, attrs), to: UserRepo

  def get_seller_user_from_order!(order), do: SellerUserFromOrder.get!(order)

  def create_auth0_user_and_get_geoposition_and_create_user(attrs),
    do: CreateAuth0UserAndGetGeopositionAndCreateUser.call(attrs)

  def delete_auth0_user_and_soft_delete_user(user),
    do: DeleteAuth0UserAndSoftDeleteUser.call(user)

  def get_updated_geoposition_and_update_user(user, attrs),
    do: GetUpdatedGeopositionAndUpdateUser.call(user, attrs)

  def update_email_in_auth0_user_and_user(user, attrs),
    do: UpdateEmailInAuth0UserAndUser.call(user, attrs)

  def update_password_in_auth0_user(user, attrs),
    do: UpdatePasswordInAuth0User.call(user, attrs)
end
