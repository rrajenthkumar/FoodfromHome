defmodule FoodFromHome.Users.UserRepoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Users.UserRepo`.
  """
  alias FoodFromHome.Users.UserRepo

  @doc """
  Generate a unique user email_id.
  """
  def unique_user_email_id, do: "john_doe_#{System.unique_integer([:positive])}@xyz.de"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: %{house_number: 10, street: "XYZ Street", city: "Darmstadt", country: "Germany"},
        phone_number: "+4912345678991",
        email_id: unique_user_email_id(),
        first_name: "John",
        gender: :male,
        last_name: "Doe",
        profile_image: "some profile_image",
        user_type: :seller
      })
      |> UserRepo.create_user()

    user
  end
end
