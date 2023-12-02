defmodule FoodFromHome.Orders.Order do
  @moduledoc """
  The Order schema.

  A brief explanation regarding how it works:

  1. Once a buyer adds the first item to the cart, an order is created with the linked cart item in the background with status ':open'.
  2. In case the buyer deletes the last item in his cart, the order is also deleted along with it.
  3. Before proceeding to checkout the buyer can update the delivery address. If he chooses to leave it blank the residential address of the buyer will be the delivery address.
  4. Once the payment by buyer is successful, :status is set to ':confirmed' and :invoice_link is added in the background by the payment management module.
  5. The seller can change the status to ':ready_for_pickup' once the food is ready or due to some reasons if he is not able to honour the order he can change the status to 'cancelled', add a seller remark and refund the payment.
  6. The deliverer can change the status of the order he choses to pickup and deliver to ':reserved_for_pickup' and then to ':on_the_way' after pickup and finally to 'delivered' after delivery.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order.DeliveryAddress
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  @allowed_create_keys [:seller_id, :buyer_user_id, :delivery_address]
  @required_keys [:seller_id, :buyer_user_id, :status, :delivery_address]
  @allowed_update_keys [:status, :delivery_address, :invoice_link, :seller_remark]
  @delivery_address_keys [:door_number, :street, :city, :country, :postal_code]

  schema "orders" do
    field :status, Ecto.Enum, values: [:open, :confirmed, :ready_for_pickup, :reserved_for_pickup, :on_the_way, :delivered, :cancelled], default: :open
    field :invoice_link, :string, default: nil
    field :seller_remark, :string, default: nil

    embeds_one :delivery_address, DeliveryAddress, on_replace: :update, validate_required: true do
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
    |> unique_constraint(:unique_open_order_per_buyer_constraint, name: :unique_open_order_per_buyer_index, message: "A buyer can have only one open order at a time.")
    |> foreign_key_constraint(:seller_id)
    |> foreign_key_constraint(:buyer_user_id)
    |> cast_embed(:delivery_address, with: &delivery_address_changeset/2)
    |> cast_assoc(:cart_item, required: true, with: &CartItem.changeset/2)
  end

  @doc """
  Changeset function for order updation.
  """
  def update_changeset(order, attrs) do
    order
    |> cast(attrs, @allowed_update_keys)
    |> validate_required(@required_keys)
    |> validate_status_change()
    |> unique_constraint(:invoice_link)
    |> unique_constraint(:unique_open_order_per_buyer_constraint, name: :unique_open_order_per_buyer_index, message: "Only one open order is allowed per buyer.")
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

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :open}, changes: %{status: new_status}}) do
    if new_status == :confirmed do
      changeset
    else
      add_error(changeset, :status, "The status cannot be updated to #{new_status} from :open status.")
    end
  end

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :confirmed}, changes: %{status: new_status}}) do
    if new_status == :ready_for_pickup or status == :cancelled do
      changeset
    else
      add_error(changeset, :status, "The status cannot be updated to #{new_status} from :confirmed status.")
    end
  end

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :cancelled}, changes: %{status: new_status}}) do
    add_error(changeset, :status, "The status cannot be updated to #{new_status} from :cancelled status.")
  end

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :ready_for_pickup}, changes: %{status: new_status}}) do
    if new_status == :reserved_for_pickup do
      changeset
    else
      add_error(changeset, :status, "The status cannot be updated to #{new_status} from :ready_for_pickup status.")
    end
  end

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :reserved_for_pickup}, changes: %{status: new_status}}) do
    if new_status == :on_the_way do
      changeset
    else
      add_error(changeset, :status, "The status cannot be updated to #{new_status} from :reserved_for_pickup status.")
    end
  end

  defp validate_status_change(changeset = %Ecto.Changeset{data: %Order{status: :on_the_way}, changes: %{status: new_status}}) do
    if new_status == :delivered do
      changeset
    else
      add_error(changeset, :status, "The status cannot be updated to #{new_status} from :on_the_way status.")
    end
  end
end
