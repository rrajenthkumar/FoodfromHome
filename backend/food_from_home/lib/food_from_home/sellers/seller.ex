defmodule FoodFromHome.Sellers.Seller do
  @moduledoc """
  The Seller schema
  When an user is of type :seller an associated seller record is created with seller specific details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils

  @allowed_create_keys [:nickname, :illustration, :introduction, :tax_id]
  @allowed_update_keys [:nickname, :illustration, :introduction]
  @required_seller_keys [:nickname, :introduction, :tax_id]

  schema "sellers" do
    field :nickname, :string
    field :illustration, :binary, default: nil
    field :introduction, :string
    field :tax_id, :string

    belongs_to :seller_user, User, foreign_key: :seller_user_id
    has_many :orders, Order
    has_many :food_menus, FoodMenu

    timestamps()
  end

  @doc """
  Changeset for a new seller record creation
  """
  def create_changeset(seller, attrs) do
    seller
    |> cast(attrs, @allowed_create_keys)
    |> validate_required(@required_seller_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_create_keys)
    |> unique_constraint(:seller_user_id)
    |> unique_constraint(:tax_id)
    |> foreign_key_constraint(:seller_user_id)
  end

  @doc """
  Changeset for seller record updation
  """
  def update_changeset(seller, attrs) do
    seller
    |> cast(attrs, @allowed_update_keys)
    |> validate_required(@required_seller_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_update_keys)
    |> unique_constraint(:seller_user_id)
    |> unique_constraint(:tax_id)
    |> foreign_key_constraint(:seller_user_id)
  end
end
