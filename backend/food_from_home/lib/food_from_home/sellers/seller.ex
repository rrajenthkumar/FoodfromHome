defmodule FoodFromHome.Sellers.Seller do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User

  @required_seller_keys [:introduction, :tax_id]
  @allowed_create_seller_keys [:illustration, :introduction, :tax_id]
  @allowed_update_seller_keys [:illustration, :introduction]

  schema "sellers" do
    field :illustration, :binary, default: nil
    field :introduction, :string
    field :tax_id, :string

    # Seller belongs to user of type :seller
    belongs_to :user, User
    has_many :orders, Order
    has_many :food_menus, FoodMenu

    timestamps()
  end

  @doc false
  def create_changeset(seller, attrs) do
    seller
    |> cast(attrs, @allowed_create_seller_keys)
    |> validate_required(@required_seller_keys)
    |> unique_constraint(:user_id)
    |> unique_constraint(:tax_id)
    |> foreign_key_constraint(:user_id)
  end

    @doc false
    def update_changeset(seller, attrs) do
      seller
      |> cast(attrs, @allowed_update_seller_keys)
      |> validate_required(@required_seller_keys)
      |> unique_constraint(:user_id)
      |> unique_constraint(:tax_id)
      |> foreign_key_constraint(:user_id)
    end
end
