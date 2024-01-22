defmodule FoodFromHome.Users.UserRepoFixtures do
  @moduledoc """
  This module defines test helpers for creating entities via the `FoodFromHome.Users.UserRepo`.
  """
  alias FoodFromHome.Users.UserRepo

  @doc """
  Generate a unique email.
  """
  def unique_email, do: "john_doe_#{System.unique_integer([:positive])}@xyz.de"

  @doc """
  Generate a unique tax_id.
  """
  def unique_tax_id, do: "xyz_#{System.unique_integer([:positive])}"

  @doc """
  Generate a user of types :buyer or :deliverer.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: %{
          door_number: "10A",
          street: "XYZ Street",
          city: "Darmstadt",
          country: "Germany",
          postal_code: "12345"
        },
        phone_number: "+4912345678991",
        email: unique_email(),
        first_name: "John",
        salutation: :Mr,
        last_name: "Doe",
        profile_image: "some profile_image",
        user_type: :buyer
      })
      |> UserRepo.create_user()

    user
  end

  @doc """
  Generate a user of type :seller.
  """
  def user_fixture_for_seller_type(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: %{
          door_number: "5B",
          street: "ABC Street",
          city: "Fulda",
          country: "Germany",
          postal_code: "54321"
        },
        phone_number: "+4911111111111",
        email: unique_email(),
        first_name: "Jane",
        salutation: :Mr,
        last_name: "Doe",
        profile_image: "some random profile_image",
        user_type: :seller,
        seller: %{
          introduction: "some seller introduction",
          illustration: "some seller illustration",
          tax_id: unique_tax_id()
        }
      })
      |> UserRepo.create_user()

    user
  end
end
