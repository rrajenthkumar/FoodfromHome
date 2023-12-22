defmodule FoodFromHome.Deliveries.Delivery do
  @moduledoc """
  The Delivery schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FoodFromHome.Deliveries.Delivery
  alias Geo.PostGIS.Geometry
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils

  @allowed_create_delivery_keys [:deliverer_user_id, :current_geoposition]
  @allowed_update_delivery_keys [
    :picked_up_at,
    :current_geoposition,
    :distance_travelled_in_kms,
    :delivered_at
  ]
  @required_delivery_keys [:deliverer_user_id, :current_geoposition]

  schema "deliveries" do
    field :picked_up_at, :utc_datetime, default: nil
    field :current_geoposition, Geometry
    field :delivered_at, :utc_datetime, default: nil
    field :distance_travelled_in_kms, :decimal, default: nil

    belongs_to :order, Order
    belongs_to :deliverer_user, User, foreign_key: :deliverer_user_id

    timestamps()
  end

  @doc """
  Changeset function for delivery creation.
  """
  def create_changeset(delivery = %Delivery{}, attrs = %{}) do
    delivery
    |> cast(attrs, @allowed_create_delivery_keys)
    |> validate_required(@required_delivery_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_create_delivery_keys)
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:deliverer_user_id)
  end

  @doc """
  Changeset function for delivery updation.
  """
  def update_changeset(delivery = %Delivery{}, attrs = %{}) do
    delivery
    |> cast(attrs, @allowed_update_delivery_keys)
    |> validate_required(@required_delivery_keys)
    |> Utils.validate_unallowed_fields(attrs, @allowed_update_delivery_keys)
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:deliverer_user_id)
  end
end
