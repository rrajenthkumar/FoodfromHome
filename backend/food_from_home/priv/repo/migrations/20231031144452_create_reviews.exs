defmodule FoodFromHome.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :stars, :string
      add :note, :text
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps()
    end

    create index(:reviews, [:order_id])
  end
end
