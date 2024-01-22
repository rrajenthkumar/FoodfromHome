defmodule FoodFromHome.Reviews.Utils do
  @moduledoc """
  Utility functions related to Review context
  """
  alias FoodFromHome.Reviews.Review

  def is_review_older_than_a_day?(%Review{inserted_at: inserted_at}) do
    {:ok, inserted_at} = DateTime.from_naive(inserted_at, "Etc/UTC")
    now = DateTime.utc_now()

    # To check if the difference is not more than 24 hours
    DateTime.diff(inserted_at, now) >= 24 * 60 * 60
  end
end
