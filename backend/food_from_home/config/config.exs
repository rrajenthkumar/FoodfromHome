# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :food_from_home,
  ecto_repos: [FoodFromHome.Repo]

config :food_from_home, FoodFromHome.Repo,
  types: FoodFromHome.PostgresTypes

# Configures the endpoint
config :food_from_home, FoodFromHomeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: FoodFromHomeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FoodFromHome.PubSub,
  live_view: [signing_salt: "l9VrxI6z"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :food_from_home, FoodFromHome.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Auth0
config :food_from_home,
  auth0: %{
    url: %URI{
      host: "rrajenthkumar-private.eu.auth0.com/",
      port: 443,
      scheme: "https"
    },
    client_id: "p6QC3xImNEFFB0RB0Km03VGytMyKyKlm",
    client_secret: "4HLGtsHe-0Itt_4B_Zz8n-ijnVwJ1XnkHW1o7-zCZoK0OvTB8c6BOvN4amnCAbl6",
    audience: "https://www.rajenthzfoodfromhome.de/",
    scope: "admin"
  }

# Guardian
config :food_from_home, FoodFromHome.Auth.Guardian,
allowed_algos: ["HS256"],
verify_module: Guardian.JWT,
issuer: "rrajenthkumar-private.eu.auth0.com/",
verify_issuer: true,
secret_key: "7RaD6ybqYwIIvc1aqgzTrMopliOLDpFy"

# Configures Kaffe, the Elixir wrapper around brod: the Erlang Kafka client
# config :kaffe,
#   producer: [
#     endpoints: [localhost: 9092],
#     topics: ["sellers searched", "seller viewed", "order confirmed", "payment failed", "payment cancelled", "delivery_started", "delivery_completed", "order cancelled"] # the topic(s) that will be produced
#   ],
#   consumer: [
#     endpoints: [localhost: 9092],
#     topics: ["sellers searched", "seller viewed", "order confirmed", "payment failed", "payment cancelled", "delivery_started", "delivery_completed", "order cancelled"], # the topic(s) that will be consumed
#     consumer_group: "food-from-home-consumer-group", # the consumer group for tracking offsets in Kafka
#     message_handler: FoodFromHome.KafkaAgent.Consumers
#   ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
