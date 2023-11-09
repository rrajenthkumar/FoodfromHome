defmodule FoodFromHome.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  schema "orders" do
    field :date, :utc_datetime
    field :delivery_address, :map
    field :status, Ecto.Enum, values: [:open, :confirmed, :ready_for_pickup, :reserved_for_pickup, :on_the_way, :delivered, :cancelled]
    field :invoice_link, :string

    belongs_to :seller, Seller
    # Order belongs to user of type :buyer
    belongs_to :user, User
    has_many :cart_items, CartItem
    has_one :delivery, Delivery
    has_one :review, Review

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:date, :delivery_address, :status, :invoice_link])
    |> validate_required([:date, :status, :invoice_link])
    |> unique_constraint(:invoice_link)
    |> foreign_key_constraint(:seller_id)
    |> foreign_key_constraint(:user_id)
  end
end
