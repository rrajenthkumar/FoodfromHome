import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :food_from_home_notifications, FoodFromHomeNotificationsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Mz4KGW8ovY4WNxF5w2KGDzx3Zk/IEx+de+7Uu63n62DcCuuE5/QAWs/nJ/R4+tPf",
  server: false

# In test we don't send emails.
config :food_from_home_notifications, FoodFromHomeNotifications.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
