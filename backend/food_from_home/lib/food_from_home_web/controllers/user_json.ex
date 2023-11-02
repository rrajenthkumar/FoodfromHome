defmodule FoodFromHomeWeb.UserJSON do
  alias FoodFromHome.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      address: user.address,
      email_id: user.email_id,
      first_name: user.first_name,
      gender: user.gender,
      last_name: user.last_name,
      profile_image: user.profile_image,
      user_type: user.user_type
    }
  end
end
