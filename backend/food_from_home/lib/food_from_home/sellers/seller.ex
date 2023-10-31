defmodule FoodFromHome.Sellers.Seller do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sellers" do
    field :illustration, :binary
    field :introduction, :string
    field :tax_id, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(seller, attrs) do
    seller
    |> cast(attrs, [:tax_id, :introduction, :illustration])
    |> validate_required([:tax_id, :introduction, :illustration])
    |> unique_constraint(:tax_id)
  end
end
