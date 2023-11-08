defmodule FoodFromHome.Sellers.SellerRepoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Sellers.SellerRepo`.
  """
  alias FoodFromHome.Sellers.SellerRepo
  alias FoodFromHome.Users.UserRepoFixtures

  @doc """
  Generate a unique seller tax_id.
  """
  def unique_seller_tax_id, do: "some tax_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a seller.
  """
  def seller_fixture(attrs \\ %{}) do
    user = UserRepoFixtures.user_fixture()

    {:ok, seller} =
      attrs
      |> Enum.into(%{
        illustration: "some illustration",
        introduction: "some introduction",
        tax_id: unique_seller_tax_id()
      })
      |> SellerRepo.create_seller(user.id)

    seller
  end
end
