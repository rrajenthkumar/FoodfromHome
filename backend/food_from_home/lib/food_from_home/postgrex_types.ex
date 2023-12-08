defmodule FoodFromHome.PostgrexTypes do
  Postgrex.Types.define(
    FoodFromHome.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )
end
