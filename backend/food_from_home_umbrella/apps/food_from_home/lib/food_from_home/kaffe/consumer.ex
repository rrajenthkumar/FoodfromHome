defmodule FoodFromHome.Kaffe.Consumer do
  @moduledoc """
  Kafka cosumer module
  """
  def handle_message(
        %{topic: "sellers_searched", key: "seller_ids", value: _seller_ids} = message
      ) do
    IO.inspect(message,
      label: "******sellers_searched Kafka message*******"
    )
  end

  def handle_message(%{topic: "seller_viewed", key: "seller_id", value: _seller_id} = message) do
    IO.inspect(message,
      label: "******seller_viewed Kafka message*******"
    )
  end

  def handle_message(
        %{topic: "food_menu_viewed", key: "food_menu_id", value: _food_menu_id} = message
      ) do
    IO.inspect(message,
      label: "******food_menu_viewed Kafka message*******"
    )
  end
end
