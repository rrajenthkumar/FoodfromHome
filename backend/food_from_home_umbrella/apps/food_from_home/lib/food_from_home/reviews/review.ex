defmodule FoodFromHome.Reviews.Review do
  @moduledoc """
  The Review schema
  After an order is delivered a buyer can add a review to the order and a seller can add a reply to a review.
  A Review cannot be updated or deleted after the seller replies to a review or if the review is older than 3 months.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Utils

  @allowed_create_keys [:rating, :buyer_note]
  @allowed_update_keys [:rating, :buyer_note, :seller_reply]
  @required_keys [:rating]

  schema "reviews" do
    field :rating, :integer
    field :buyer_note, :string, default: nil
    field :seller_reply, :string, default: nil

    belongs_to :order, Order

    timestamps()
  end

  @doc """
  Changeset function for creating a review
  """
  def create_changeset(review, attrs) do
    review
    |> cast(attrs, @allowed_create_keys)
    |> validate_required(@required_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_create_keys)
    |> validate_rating()
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
  end

  @doc """
  Changeset function for updating a review
  """
  def update_changeset(review, attrs) do
    review
    |> cast(attrs, @allowed_update_keys)
    |> validate_required(@required_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_update_keys)
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
          "Rating must have one of the following values : 1, 2, 3, 4, 5"
        )
    end
  end
end
