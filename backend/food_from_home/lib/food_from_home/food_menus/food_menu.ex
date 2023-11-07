defmodule FoodFromHome.FoodMenus.FoodMenu do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Sellers.Seller

  schema "food_menus" do
    field :name, :string
    field :description, :string
    field :menu_illustration, :binary
    field :ingredients, {:array, :string}
    field :allergens, {:array, :string}, default: []
    field :price, :decimal
    field :rebate, :map, default: nil
    field :valid_until, :utc_datetime
    field :preparation_time_in_minutes, :integer

    belongs_to :seller, Seller
    has_many :cart_items, CartItem

    timestamps()
  end

  @doc false
  def changeset(food_menu, attrs) do
    food_menu
    |> cast(attrs, [:name, :description, :ingredients, :allergens, :price, :rebate, :menu_illustration, :preparation_time_in_minutes, :valid_until])
    |> validate_required([:name, :description, :ingredients, :price, :menu_illustration, :preparation_time_in_minutes, :valid_until])
    |> unique_constraint(:seller_id_name_valid_until_constraint, name: :seller_id_name_valid_until_index)
  end
end
