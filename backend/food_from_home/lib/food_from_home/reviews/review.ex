defmodule FoodFromHome.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Orders.Order

  schema "reviews" do
    field :rating, Ecto.Enum, values: [:"1", :"2", :"3", :"4", :"5"]
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
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
  end
end
