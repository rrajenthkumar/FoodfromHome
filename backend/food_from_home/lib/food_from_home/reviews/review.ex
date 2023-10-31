defmodule FoodFromHome.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :note, :string
    field :stars, Ecto.Enum, values: [:"1", :"2", :"3", :"4", :"5"]
    field :order_id, :id

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:stars, :note])
    |> validate_required([:stars, :note])
  end
end
