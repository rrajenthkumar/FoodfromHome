defmodule FoodFromHome.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :address, :map
    field :email_id, :string
    field :first_name, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :last_name, :string
    field :profile_image, :binary
    field :user_type, Ecto.Enum, values: [:buyer, :seller]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email_id, :address, :gender, :profile_image, :user_type])
    |> validate_required([:first_name, :last_name, :email_id, :gender, :profile_image, :user_type])
    |> unique_constraint(:email_id)
  end
end
