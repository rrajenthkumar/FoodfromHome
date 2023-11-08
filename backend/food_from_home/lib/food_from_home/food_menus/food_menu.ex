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
    |> cast(attrs, [:seller_id, :name, :description, :menu_illustration, :ingredients, :allergens, :price, :rebate, :valid_until, :preparation_time_in_minutes])
    |> validate_required([:seller_id, :name, :description, :menu_illustration, :ingredients, :price, :valid_until, :preparation_time_in_minutes])
    |> unique_constraint(:seller_id_name_valid_until_constraint, name: :seller_id_name_valid_until_index)
    |> foreign_key_constraint(:seller_id)
  end
end
