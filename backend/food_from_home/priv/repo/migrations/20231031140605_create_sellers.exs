defmodule FoodFromHome.Repo.Migrations.CreateSellers do
  use Ecto.Migration

  def change do
    create table(:sellers) do
      add :seller_user_id, references(:users, on_delete: :nothing)
      add :illustration, :binary, default: nil
      add :introduction, :text
      add :tax_id, :string


      timestamps()
    end

    create unique_index(:sellers, [:tax_id])
    create unique_index(:sellers, [:seller_user_id])
  end
end
