defmodule FoodFromHome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :address, :map
      add :phone_number, :string
      add :salutation, :string
      add :profile_image, :binary, default: nil
      add :user_type, :string
      add :geoposition, :geometry
      add :deleted, :boolean, default: false

      timestamps()
    end

    create index(:users, [:deleted])

    create unique_index(:users, [:email],
             where: "deleted is false",
             name: :unique_active_user_email_index
           )
  end
end
