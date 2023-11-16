defmodule FoodFromHome.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @allowed_create_user_keys [:email_id, :first_name, :last_name, :gender, :phone_number, :user_type, :profile_image]
  @required_create_user_keys [:email_id, :first_name, :last_name, :gender, :phone_number, :user_type]
  #TO DO: :user_type, :deleted have been allowed so that validate_exclusion can be used on changeset. This solution has to be improved.
  @allowed_update_user_keys [:email_id, :first_name, :last_name, :gender, :phone_number, :user_type, :deleted, :profile_image]
  @required_update_user_keys [:email_id, :first_name, :last_name, :gender, :phone_number]
  @address_keys [:door_number, :street, :city, :country, :postal_code]

  schema "users" do
    field :email_id, :string
    field :first_name, :string
    field :last_name, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary]
    field :phone_number, :string
    field :user_type, Ecto.Enum, values: [:buyer, :seller, :deliverer]
    field :profile_image, :binary, default: nil
    field :deleted, :boolean, default: false

    embeds_one :address, Address, on_replace: :update do
      field :door_number, :string
      field :street, :string
      field :city, :string
      field :country, :string
      field :postal_code, :string
    end

    has_one :seller, Seller, on_replace: :update
    has_many :orders, Order
    has_many :deliveries, Delivery

    timestamps()
  end

  @doc """
  1. Changeset function for new user creation for :seller user type.
  2. Changeset function for new user creation for other user types.
  """
  def create_changeset(user = %User{}, attrs = %{user_type: :seller}) do
    user
    |> cast(attrs, @allowed_create_user_keys)
    |> validate_required(@required_create_user_keys)
    |> unique_constraint(:email_id, name: :index_for_uniqueness_of_email_id_of_active_users)
    |> validate_format(:email_id, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
    |> cast_assoc(:seller, required: true, with: &Seller.changeset/2)
  end

  def create_changeset(user = %User{}, attrs = %{}) do
    user
    |> cast(attrs, @allowed_create_user_keys)
    |> validate_required(@required_create_user_keys)
    |> unique_constraint(:email_id, name: :index_for_uniqueness_of_email_id_of_active_users)
    |> validate_format(:email_id, ~r/@/)
    |> cast_embed(:address, required: true, with: &address_changeset/2)
  end

  @doc """
  Changeset function for user updation.
  Please note that Seller schema data has been disallowed from updating it through User context (though it is created initially through User context).
  Use Seller context for seller data updation.
  """
  def update_changeset(user = %User{}, attrs = %{}) do
    user
    |> cast(attrs, @allowed_update_user_keys)
    |> validate_required(@required_update_user_keys)
    |> validate_exclusion(:user_type, [:buyer, :seller, :deliverer], message: "user_type field cannot be updated")
    |> validate_exclusion(:deleted, [true, false], message: "deleted field cannot be updated")
    |> unique_constraint(:email_id, name: :index_for_uniqueness_of_email_id_of_active_users)
    |> validate_format(:email_id, ~r/@/)
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
  def address_changeset(address= %Address{}, attrs = %{}) do
    address
    |> cast(attrs, @address_keys)
    |> validate_required(@address_keys)
  end
end
