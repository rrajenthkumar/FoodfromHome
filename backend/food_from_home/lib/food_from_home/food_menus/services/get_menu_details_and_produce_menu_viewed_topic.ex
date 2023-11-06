defmodule FoodFromHome.FoodMenus.Services.GetMenuDetailsAndProduceMenuViewedTopic do
@moduledoc """
"""
alias FoodFromHome.FoodMenus.FoodMenu
alias FoodFromHome.FoodMenus.FoodMenuRepo
alias FoodFromHome.KafkaAgent.Producers

  def call(menu_id) do
    with food_menu = %FoodMenu{} <- FoodMenuRepo.get_food_menu!(menu_id) do
      #Producers.produce_menu_viewed_message(menu_id, user_id)
      Producers.produce_menu_viewed_message(menu_id)
      food_menu
    end
  end
end
