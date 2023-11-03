defmodule FoodFromHome.Repo.Migrations.CreateDeliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :order_id, references(:orders, on_delete: :nothing)
      add :deliverer_user_id, references(:users, on_delete: :nothing)
      add :picked_up_at, :utc_datetime
      add :current_position, :geometry
      add :delivered_at, :utc_datetime
      add :distance_travelled_in_kms, :decimal

      timestamps()
    end

    create unique_index(:deliveries, [:order_id])
    create index(:deliveries, [:deliverer_user_id])
  end
end
