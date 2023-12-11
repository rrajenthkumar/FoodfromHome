defmodule FoodFromHome.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :rating, :integer
      add :buyer_note, :text, default: nil
      add :seller_reply, :text, default: nil
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:reviews, [:order_id])
  end
end
