defmodule FoodFromHome.CartItems.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order

  @allowed_keys [:count, :remark]
  @required_keys [:count]

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
    |> cast(attrs, [@allowed_keys])
    |> validate_required([@required_keys])
    |> validate_remaining_quantity()
    |> unique_constraint(:unique_food_menu_id_order_id_combo_constraint,
      name: :unique_food_menu_id_order_id_combo_index,
      message: "A cart item with the same food menu id, order id combination exists."
    )
    |> foreign_key_constraint(:food_menu_id)
    |> foreign_key_constraint(:order_id)
  end

  defp validate_remaining_quantity(
         changeset = %Ecto.Changeset{
           data: %CartItem{food_menu_id: food_menu_id, count: required_food_menu_count}
         }
       ) do
    %FoodMenu{remaining_quantity: food_menu_remaining_quantity} = FoodMenus.get!(food_menu_id)

    if food_menu_remaining_quantity - required_food_menu_count >= 0 do
      changeset
    else
      add_error(
        changeset,
        :base,
        "Remaining quantity of the selected food menu is not sufficient"
      )
    end
  end
end
