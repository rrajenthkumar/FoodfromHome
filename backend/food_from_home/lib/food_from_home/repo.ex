defmodule FoodFromHome.Repo do
  use Ecto.Repo,
    otp_app: :food_from_home,
    adapter: Ecto.Adapters.Postgres
end
