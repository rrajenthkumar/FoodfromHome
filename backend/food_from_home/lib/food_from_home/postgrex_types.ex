defmodule FoodFromHome.PostgrexTypes do
  @moduledoc false
  Postgrex.Types.define(
    FoodFromHome.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )
end
