defmodule FoodFromHome.CartItems do
  @moduledoc """
  The CartItems context.
  """
  alias FoodFromHome.CartItems.CartItemRepo
  alias FoodFromHome.CartItems.Finders.CartItemsFromOrder
  alias FoodFromHome.CartItems.Services.CreateCartItemAndUpdateFoodMenuRemainingQuantity
  alias FoodFromHome.CartItems.Services.UpdateCartItemAndUpdateFoodMenuRemainingQuantity

  defdelegate get_cart_item(cart_item_id), to: CartItemRepo
  defdelegate get_cart_item!(cart_item_id), to: CartItemRepo
  defdelegate delete_cart_item(cart_item), to: CartItemRepo

  def create_cart_item_and_update_food_menu_remaining_quantity(order, attrs),
    do: CreateCartItemAndUpdateFoodMenuRemainingQuantity.call(order, attrs)

  def update_cart_item_and_update_food_menu_remaining_quantity(cart_item, attrs),
    do: UpdateCartItemAndUpdateFoodMenuRemainingQuantity.call(cart_item, attrs)

  def list_cart_items_from_order(order), do: CartItemsFromOrder.list(order)
end
