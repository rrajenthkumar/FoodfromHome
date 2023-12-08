defmodule FoodFromHome.KafkaAgent.Consumers do
  @moduledoc """
  All Kafka consumer functions
  """
  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      IO.inspect(message)
      IO.puts("#{key}: #{value}")
    end

    # Important!
    :ok
  end
end
