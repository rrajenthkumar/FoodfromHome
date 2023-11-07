defmodule FoodFromHome.CartItems.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order

  schema "cart_items" do
    field :count, :integer
    field :remark, :string

    belongs_to :order, Order
    belongs_to :food_menu, FoodMenu

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:count, :remark])
    |> validate_required([:count])
    |> unique_constraint(:order_id_food_menu_id_index_constraint, name: :order_id_food_menu_id_index)
    |> foreign_key_constraint(:food_menu_id)
    |> foreign_key_constraint(:order_id)
  end
end
