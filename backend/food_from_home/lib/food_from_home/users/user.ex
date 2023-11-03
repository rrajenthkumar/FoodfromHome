defmodule FoodFromHome.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller

  schema "users" do

    field :email_id, :string
    field :first_name, :string
    field :last_name, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :address, :map
    field :user_type, Ecto.Enum, values: [:buyer, :seller, :deliverer]
    field :profile_image, :binary

    has_one :seller, Seller, foreign_key: :seller_user_id
    has_many :orders, Order, foreign_key: :buyer_user_id
    has_many :deliveries, Delivery, foreign_key: :deliverer_user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email_id, :address, :gender, :profile_image, :user_type])
    |> validate_required([:first_name, :last_name, :email_id, :gender, :user_type, :address])
    |> unique_constraint(:email_id)
  end
end
