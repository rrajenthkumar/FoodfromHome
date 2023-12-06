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
  def create_changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:food_menu_id, :count, :remark])
    |> validate_required([:food_menu_id, :count])
    |> unique_constraint(:unique_food_menu_id_order_id_combo_constraint, name: :unique_food_menu_id_order_id_combo_index, message: "A cart item with the same food menu id, order id combination exists.")
    |> foreign_key_constraint(:food_menu_id)
    |> foreign_key_constraint(:order_id)
  end

    @doc false
    def update_changeset(cart_item, attrs) do
      cart_item
      |> cast(attrs, [:order_id, :food_menu_id, :count, :remark])
      |> validate_required([:order_id, :food_menu_id, :count])
      |> unique_constraint(:unique_food_menu_id_order_id_combo_constraint, name: :unique_food_menu_id_order_id_combo_index, message: "A cart item with the same food menu id, order id combination exists.")
      |> foreign_key_constraint(:food_menu_id)
      |> foreign_key_constraint(:order_id)
    end
end
