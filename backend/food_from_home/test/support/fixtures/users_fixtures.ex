defmodule FoodFromHome.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Users` context.
  """

  @doc """
  Generate a unique user email_id.
  """
  def unique_user_email_id, do: "some email_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: %{},
        phone_number: "+4912345678991",
        email_id: unique_user_email_id(),
        first_name: "some first_name",
        gender: :male,
        last_name: "some last_name",
        profile_image: "some profile_image",
        user_type: :buyer
      })
      |> FoodFromHome.Users.create_user()

    user
  end
end
