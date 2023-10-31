defmodule FoodFromHome.CartItems.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :count, :integer
    field :remark, :string
    field :order_id, :id
    field :food_menu_id, :id

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:count, :remark])
    |> validate_required([:count, :remark])
  end
end
