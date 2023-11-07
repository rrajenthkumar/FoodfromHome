defmodule FoodFromHome.Sellers.Seller do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  schema "sellers" do
    field :illustration, :binary
    field :introduction, :string
    field :tax_id, :string

    # Seller belongs to user of type :seller
    belongs_to :user, User
    has_many :orders, Order
    has_many :food_menus, FoodMenu

    timestamps()
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:tax_id, :introduction, :illustration])
    |> validate_required([:tax_id, :introduction])
    |> unique_constraint(:tax_id, :seller_user_id)
    |> foreign_key_constraint(:user_id)
  end
end
