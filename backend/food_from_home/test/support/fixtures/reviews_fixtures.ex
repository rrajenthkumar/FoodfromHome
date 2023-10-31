defmodule FoodFromHome.ReviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodFromHome.Reviews` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(attrs \\ %{}) do
    {:ok, review} =
      attrs
      |> Enum.into(%{
        note: "some note",
        stars: :"1"
      })
      |> FoodFromHome.Reviews.create_review()

    review
  end
end
