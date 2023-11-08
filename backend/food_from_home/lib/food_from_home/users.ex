defmodule FoodFromHome.Users do
  @moduledoc """
  The Users context.
  """
  alias FoodFromHome.Users.UserRepo

  defdelegate create_user(attrs), to: UserRepo
  defdelegate get_user!(user_id), to: UserRepo
  defdelegate get_active_user_from_email_id!(email_id), to: UserRepo
  defdelegate update_user(user_id, attrs), to: UserRepo  #Used by API route
  defdelegate mark_user_as_deleted(user_id), to: UserRepo
end
