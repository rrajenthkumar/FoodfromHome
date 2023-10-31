defmodule FoodFromHome.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :date, :utc_datetime
    field :delivery_address, :map
    field :invoice_link, :string
    field :status, Ecto.Enum, values: [:open, :created, :ready_for_delivery, :on_the_way, :delivered, :cancelled, :archived]
    field :seller_id, :id
    field :buyer_id, :id

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:date, :delivery_address, :status, :invoice_link])
    |> validate_required([:date, :status, :invoice_link])
  end
end
