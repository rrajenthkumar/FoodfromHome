import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :food_from_home, FoodFromHome.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "food_from_home_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :food_from_home, FoodFromHomeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HUvQierpQ7+ouuiSzg/PWosWmoFsJs3d96tOJgoj5+KjvoayZVgJ+0cwDfvaG7Zu",
  server: false

# In test we don't send emails.
config :food_from_home, FoodFromHome.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Auth0
config :food_from_home,
  auth0: %{
    url: %URI{
      host: "localhost",
      port: 3200,
      scheme: "http"
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
