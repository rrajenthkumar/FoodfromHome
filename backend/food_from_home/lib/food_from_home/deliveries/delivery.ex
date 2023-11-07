defmodule FoodFromHome.Deliveries.Delivery do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users.User
  alias Geo.PostGIS.Geometry

  schema "deliveries" do
    field :picked_up_at, :utc_datetime
    field :current_position, Geometry
    field :delivered_at, :utc_datetime
    field :distance_travelled_in_kms, :decimal

    belongs_to :order, Order
    # Delivery belongs to user of type :deliverer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:picked_up_at,:current_position, :delivered_at, :distance_travelled_in_kms])
    |> validate_required([:picked_up_at, :current_position])
    |> unique_constraint(:order_id)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:user_id)
  end
end
