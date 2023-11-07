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
    field :profile_image, :binary
    field :deleted, :boolean

    has_one :seller, Seller
    has_many :orders, Order
    has_many :deliveries, Delivery

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email_id, :address, :phone_number, :gender, :profile_image, :user_type, :deleted])
    |> validate_required([:first_name, :last_name, :email_id, :gender, :user_type, :address, :phone_number])
    |> unique_constraint(:email_id, name: :index_for_uniqueness_of_email_id_of_active_users)
    |> validate_format(:email_id, ~r/@/)
  end
end
