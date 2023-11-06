defmodule FoodFromHome.FoodMenus do
  @moduledoc """
  The FoodMenus context which is the interface for other contexts.
  """
  alias FoodFromHome.FoodMenus.Services
  alias FoodFromHome.FoodMenus.FoodMenuRepo

  def get_menu_details_and_produce_menu_viewed_topic(menu_id) do
    Services.GetMenuDetailsAndProduceMenuViewedTopic.call(menu_id)
  end

  def list_active_food_menus_from_seller(seller_id) do
    defdelegate list_active_food_menus_from_seller(seller_id), to: FoodMenuRepo
  end

  def create_food_menu(attrs) do
    defdelegate create_food_menu(attrs), to: FoodMenuRepo
  end

  def update_food_menu(menu_id, attrs) do
    defdelegate update_food_menu(menu_id, attrs), to: FoodMenuRepo
  end

  def delete_food_menu(menu_id) do
    defdelegate delete_food_menu(menu_id), to: FoodMenuRepo
  end
end
