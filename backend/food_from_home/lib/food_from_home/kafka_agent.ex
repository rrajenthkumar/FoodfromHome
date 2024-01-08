defmodule FoodFromHome.KafkaAgent do
  @moduledoc """
  Module to manage interaction with Kafka
  """
  alias FoodFromHome.KafkaAgent.Producer

  def produce_message(topic, key, message), do: Producer.call(topic, key, message)
end
