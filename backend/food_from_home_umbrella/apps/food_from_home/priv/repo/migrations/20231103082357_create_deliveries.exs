defmodule FoodFromHome.Repo.Migrations.CreateDeliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :order_id, references(:orders, on_delete: :nothing)
      add :deliverer_user_id, references(:users, on_delete: :nothing)
      add :picked_up_at, :utc_datetime, default: nil
      add :current_geoposition, :geometry
      add :delivered_at, :utc_datetime, default: nil
      add :distance_travelled_in_kms, :decimal, default: nil

      timestamps()
    end

    create unique_index(:deliveries, [:order_id])
    create index(:deliveries, [:deliverer_user_id])
  end
end
