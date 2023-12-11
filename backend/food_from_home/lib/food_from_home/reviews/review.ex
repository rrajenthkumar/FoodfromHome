defmodule FoodFromHome.Reviews.Review do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Reviews.Review

  schema "reviews" do
    field :rating, :integer
    field :buyer_note, :string, default: nil
    field :seller_reply, :string, default: nil

    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:stars, :buyer_note, :seller_reply])
    |> validate_required([:rating])
    |> validate_rating()
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
  end

  defp validate_rating(
         changeset = %Ecto.Changeset{
           data: %Review{rating: rating}
         }
       ) do
    case rating in [1, 2, 3, 4, 5] do
      true ->
        changeset

      false ->
        add_error(
          changeset,
          :rating,
          "Rating must have one of the following values : 1, 2, 3, 4, 5."
        )
    end
  end
end
