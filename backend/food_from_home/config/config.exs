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
  http: [:inet6, port: 4000],
  server: true,
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

config :ueberauth, Ueberauth,
  providers: [
    auth0: {Ueberauth.Strategy.Auth0, []}
  ]

config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  client_id: "9PWU23oPd307UdtdyzzieBoPZpUQpgxe",
  client_secret: "UkeV6vcX7P4RoWkbW5kQZYOU7HxN6zh2c7WpoSX0VtxQvpfLrXi96yFoQoXOgQX5",
  redirect_uri: "http://localhost:4000/auth/auth0/callback"

config :food_from_home, GoogleGeocodingAPI,
  key: "AIzaSyAxSFulsPgHOOyA5IXkCS4XGjYtro8O8SI"

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
