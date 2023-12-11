defmodule FoodFromHome.KafkaAgent.Consumers do
  @moduledoc """
  All Kafka consumer functions
  """
  def handle_messages(messages) do
    for %{key: key, value: value} = _message <- messages do
      IO.puts("#{key}: #{value}")
    end

    # Important!
    :ok
  end
end
