defmodule FoodFromHome.CartItems.Services.CreateCartItemAndUpdateFoodMenuRemainingQuantity do
  @moduledoc """
  Creates a new cart item and updates the :available_quantity field of the related food menu
  """
  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.CartItems.CartItemRepo
  alias FoodFromHome.FoodMenus
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order

  def call(order = %Order{}, attrs = %{food_menu_id: food_menu_id, count: count}) do
    with {:ok, %CartItem{}} <- CartItemRepo.create_cart_item(order, attrs) do
      food_menu =
        %FoodMenu{remaining_quantity: remaining_quantity} = FoodMenus.get_food_menu!(food_menu_id)

      remaining_quantity = remaining_quantity - count
      FoodMenus.update_food_menu(food_menu, _attrs = %{remaining_quantity: remaining_quantity})
    end
  end
end
