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
    field :phone_number, :string
    field :user_type, Ecto.Enum, values: [:buyer, :seller, :deliverer]
    field :profile_image, :binary, default: nil
    field :deleted, :boolean, default: false

    has_one :seller, Seller
    has_many :orders, Order
    has_many :deliveries, Delivery

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email_id, :first_name, :last_name, :gender, :address, :phone_number, :user_type, :profile_image, :deleted])
    |> validate_required([:email_id, :first_name, :last_name, :gender, :address, :phone_number, :user_type])
    |> unique_constraint(:email_id, name: :index_for_uniqueness_of_email_id_of_active_users)
    |> validate_format(:email_id, ~r/@/)
  end
end
