defmodule FoodFromHome.FoodMenus.FoodMenu do
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_menus" do
    field :allergens, Ecto.Enum, values: [:lactose, :gluten]
    field :description, :string
    field :ingredients, Ecto.Enum, values: [:egg, :sugar]
    field :menu_illustration, :binary
    field :name, :string
    field :preparation_time_in_minutes, :integer
    field :price, :decimal
    field :rebate, :map
    field :valid_until, :utc_datetime
    field :seller_id, :id

    timestamps()
  end

  @doc false
  def changeset(food_menu, attrs) do
    food_menu
    |> cast(attrs, [:name, :description, :ingredients, :allergens, :price, :rebate, :menu_illustration, :preparation_time_in_minutes, :valid_until])
    |> validate_required([:name, :description, :ingredients, :allergens, :price, :menu_illustration, :preparation_time_in_minutes, :valid_until])
  end
end
