defmodule FoodFromHome.Repo.Migrations.CreateSellers do
  use Ecto.Migration

  def change do
    create table(:sellers) do
      add :tax_id, :string
      add :introduction, :text
      add :illustration, :binary
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:sellers, [:tax_id])
    create index(:sellers, [:user_id])
  end
end
