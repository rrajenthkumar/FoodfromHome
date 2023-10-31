defmodule FoodFromHome.SellersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Sellers` context.
  """

  @doc """
  Generate a unique seller tax_id.
  """
  def unique_seller_tax_id, do: "some tax_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a seller.
  """
  def seller_fixture(attrs \\ %{}) do
    {:ok, seller} =
      attrs
      |> Enum.into(%{
        illustration: "some illustration",
        introduction: "some introduction",
        tax_id: unique_seller_tax_id()
      })
      |> FoodFromHome.Sellers.create_seller()

    seller
  end
end
