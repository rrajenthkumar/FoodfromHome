defmodule FoodFromHome.Users.User do
  @moduledoc """
  The User schema
  When a new user registers an User is created.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address
  alias FoodFromHome.Utils
  alias Geo.PostGIS.Geometry

  @allowed_create_user_keys [
    :email,
    :first_name,
    :last_name,
    :salutation,
    :phone_number,
    :user_type,
    :profile_image,
    :geoposition
  ]
  @allowed_update_user_keys [
    :email,
    :first_name,
    :last_name,
    :salutation,
    :phone_number,
    :profile_image,
    :geoposition
  ]
  @required_user_keys [
    :email,
    :first_name,
    :last_name,
    :salutation,
    :phone_number,
    :user_type,
    :geoposition
  ]
  @address_keys [:door_number, :street, :city, :country, :postal_code]

  @allowed_create_seller_keys [:nickname, :illustration, :introduction, :tax_id]

  @allowed_update_seller_keys [:nickname, :illustration, :introduction]

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :salutation, Ecto.Enum, values: [:Mr, :Mrs, :Ms]
    field :phone_number, :string
    field :user_type, Ecto.Enum, values: [:buyer, :seller, :deliverer]
    field :profile_image, :binary, default: nil
    field :geoposition, Geometry
    field :deleted, :boolean, default: false

    embeds_one :address, Address, on_replace: :update do
      field :door_number, :string
      field :street, :string
      field :city, :string
      field :country, :string
      field :postal_code, :string
    end

    has_one :seller, Seller,
      on_replace: :update,
      on_delete: :delete_all,
      foreign_key: :seller_user_id

    has_many :orders, Order, foreign_key: :buyer_user_id
    has_many :deliveries, Delivery, foreign_key: :deliverer_user_id

    timestamps()
  end

  @doc """
  1. Changeset function for new user creation for :seller user type.
  2. Changeset function for new user creation for other user types.
  """
  def create_changeset(user = %User{}, attrs = %{user_type: :seller}) do
    user
    |> cast(attrs, @allowed_create_user_keys)
    |> validate_required(@required_user_keys)
    |> Utils.validate_unallowed_fields(
      attrs,
      @allowed_create_user_keys ++ [:address] ++ @allowed_create_seller_keys
    )
    |> unique_constraint(:unique_active_user_email_constraint,
      name: :unique_active_user_email_index,
      message: "Another active user has the same email id."
    )
    |> validate_format(:email, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
    |> cast_assoc(:seller, required: true, with: &Seller.create_changeset/2)
  end

  def create_changeset(user = %User{}, attrs = %{}) do
    user
    |> cast(attrs, @allowed_create_user_keys)
    |> validate_required(@required_user_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_create_user_keys ++ [:address])
    |> unique_constraint(:unique_active_user_email_constraint,
      name: :unique_active_user_email_index,
      message: "Another active user has the same email id."
    )
    |> validate_format(:email, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
  end

  @doc """
  1. Changeset function for user updation for :seller user type.
  2. Changeset function for user updation for other user types.
  """
  def update_changeset(user = %User{user_type: :seller}, attrs = %{}) do
    user
    |> cast(attrs, @allowed_update_user_keys)
    |> validate_required(@required_user_keys)
    |> Utils.validate_unallowed_fields(
      attrs,
      @allowed_update_user_keys ++ [:address] ++ @allowed_update_seller_keys
    )
    |> unique_constraint(:unique_active_user_email_constraint,
      name: :unique_active_user_email_index,
      message: "Another active user has the same email id."
    )
    |> validate_format(:email, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
    |> cast_assoc(:seller, required: true, with: &Seller.update_changeset/2)
  end

  def update_changeset(user = %User{}, attrs = %{}) do
    user
    |> cast(attrs, @allowed_update_user_keys)
    |> validate_required(@required_user_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_update_user_keys ++ [:address])
    |> unique_constraint(:unique_active_user_email_constraint,
      name: :unique_active_user_email_index,
      message: "Another active user has the same email id."
    )
    |> validate_format(:email, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
  end

  @doc """
  Changeset function for user (soft) deletion.
  Whenever an user is to be deleted, the 'deleted' field is set to true rather than removing the data completely from table, to preserve history.
  """
  def soft_delete_changeset(user = %User{}) do
    change(user, %{deleted: true})
  end

  @doc """
  Changeset function for Address schema.
  """
  def address_changeset(address = %Address{}, attrs = %{}) do
    address
    |> cast(attrs, @address_keys)
    |> validate_required(@address_keys)
  end
end
