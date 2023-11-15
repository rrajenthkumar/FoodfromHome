defmodule FoodFromHome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email_id, :string
      add :address, :map
      add :phone_number, :string
      add :gender, :string
      add :profile_image, :binary, default: nil
      add :user_type, :string
      add :deleted, :boolean, default: false

      timestamps()
    end

    create index(:users, [:deleted])
    create unique_index(:users, [:email_id], where: "deleted is false", name: :index_for_uniqueness_of_email_id_of_active_users)
  end
end
