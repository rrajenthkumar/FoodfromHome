defmodule FoodFromHome.KafkaAgent do
  @moduledoc """
  Module for Kafka producers and consumers
  Following are the topics involved:
  1. sellers searched
  2. seller viewed
  3. food menu viewed
  4. order confirmed
  5. payment failed
  6. payment cancelled
  7. delivery_started
  8. delivery_completed
  9. order cancelled"
  """

  alias FoodFromHome.KafkaAgent.Producers

  defdelegate produce_menu_viewed_message(menu_id), to: Producers

end
