defmodule FoodFromHome.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order.DeliveryAddress
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  @allowed_create_keys [:seller_id, :buyer_user_id]
  @required_keys [:seller_id, :buyer_user_id, :status]
  @allowed_update_keys [:status, :invoice_link, :seller_remark]
  @delivery_address_keys [:door_number, :street, :city, :country, :postal_code]

  schema "orders" do
    field :status, Ecto.Enum, values: [:open, :confirmed, :ready_for_pickup, :reserved_for_pickup, :on_the_way, :delivered, :cancelled], default: :open
    field :invoice_link, :string, default: nil
    field :seller_remark, :string, default: nil

    embeds_one :delivery_address, DeliveryAddress, on_replace: :update do
      field :door_number, :string
      field :street, :string
      field :city, :string
      field :country, :string
      field :postal_code, :string
    end

    belongs_to :seller, Seller
    # Order belongs to user of type :buyer
    belongs_to :user, User
    has_many :cart_items, CartItem
    has_one :delivery, Delivery
    has_one :review, Review

    timestamps()
  end

  @doc """
  Changeset function for order creation.
  """
  def create_changeset(order, attrs) do
    order
    |> cast(attrs, @allowed_create_keys)
    |> validate_required(@required_keys)
    |> unique_constraint(:invoice_link)
    |> foreign_key_constraint(:seller_id)
    |> foreign_key_constraint(:buyer_user_id)
    |> cast_embed(:delivery_address, with: &delivery_address_changeset/2)
  end

  @doc """
  Changeset function for order updation.
  """
  def update_changeset(order, attrs) do
    order
    |> cast(attrs, @allowed_update_keys)
    |> validate_required(@required_keys)
    |> unique_constraint(:invoice_link)
    |> foreign_key_constraint(:seller_id)
    |> foreign_key_constraint(:buyer_user_id)
    |> cast_embed(:delivery_address, with: &delivery_address_changeset/2)
  end

  @doc """
  Changeset function for delivery address schema.
  """
  def delivery_address_changeset(delivery_address= %DeliveryAddress{}, attrs = %{}) do
    delivery_address
    |> cast(attrs, @delivery_address_keys)
    |> validate_required(@delivery_address_keys)
  end
end
