defmodule FoodFromHome.CartItems.CartItem do
  @moduledoc """
  The CartItem schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Utils

  @allowed_keys [:food_menu_id, :count, :remark]
  @required_keys [:food_menu_id, :count]

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
    |> cast(attrs, @allowed_keys)
    |> validate_required(@required_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_keys)
    |> validate_number(:count, greater_than_or_equal_to: 1)
    |> unique_constraint(:unique_food_menu_id_order_id_combo_constraint,
      name: :unique_food_menu_id_order_id_combo_index,
      message: "A cart item with the same food menu id, order id combination exists."
    )
    |> foreign_key_constraint(:food_menu_id)
    |> foreign_key_constraint(:order_id)
    |> validate_foodmenu_availability()
  end

  defp validate_foodmenu_availability(
         changeset = %Ecto.Changeset{
           data: %CartItem{},
           changes: %{food_menu_id: food_menu_id, count: required_food_menu_count}
         }
       ) do
    %FoodMenu{remaining_quantity: food_menu_remaining_quantity} =
      FoodMenus.get_food_menu!(food_menu_id)

    if food_menu_remaining_quantity - required_food_menu_count >= 0 do
      changeset
    else
      add_error(
        changeset,
        :count,
        "Remaining quantity of the selected food menu is not sufficient fo fulfil the requested cart item count"
      )
    end
  end
end
