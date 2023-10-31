defmodule FoodFromHome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email_id, :string
      add :address, :map
      add :gender, :string
      add :profile_image, :binary
      add :user_type, :string

      timestamps()
    end

    create unique_index(:users, [:email_id])
  end
end
