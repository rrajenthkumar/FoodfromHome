defmodule FoodFromHome.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Orders.Order

  schema "reviews" do
    field :stars, Ecto.Enum, values: [:"1", :"2", :"3", :"4", :"5"]
    field :note, :string

    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:stars, :note])
    |> validate_required([:stars])
    |> unique_constraint(:order_id)
  end
end
