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
    |> cast(attrs, [:user_id, :illustration, :introduction, :tax_id])
    |> validate_required([:user_id, :introduction, :tax_id])
    |> unique_constraint(:user_id)
    |> unique_constraint(:tax_id)
    |> foreign_key_constraint(:user_id)
  end
end
