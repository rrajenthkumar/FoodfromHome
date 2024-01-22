defmodule FoodFromHome.CartItems.Services.UpdateCartItemAndUpdateFoodMenuRemainingQuantity do
  @moduledoc """
  Updates a cart item and updates the :available_quantity field of the related food menu if applicable
  """
  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.CartItems.CartItemRepo
  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu

  def call(cart_item = %CartItem{count: old_count}, attrs = %{count: new_count}) do
    with {:ok, %CartItem{food_menu_id: food_menu_id}} <-
           CartItemRepo.update_cart_item(cart_item, attrs) do
      food_menu =
        %FoodMenu{remaining_quantity: remaining_quantity} = FoodMenus.get_food_menu!(food_menu_id)

      remaining_quantity = remaining_quantity + old_count - new_count
      FoodMenus.update_food_menu(food_menu, _attrs = %{remaining_quantity: remaining_quantity})
    end
  end

  def call(cart_item = %CartItem{}, attrs = %{}) do
    CartItemRepo.update_cart_item(cart_item, attrs)
  end
end
