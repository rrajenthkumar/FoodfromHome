defmodule FoodFromHomeNotifications.Repo do
  use Ecto.Repo,
    otp_app: :food_from_home_notifications,
    adapter: Ecto.Adapters.Postgres
end
