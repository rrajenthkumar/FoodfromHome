defmodule FoodFromHome.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :date, :utc_datetime
      add :delivery_address, :map
      add :status, :string
      add :invoice_link, :string
      add :seller_id, references(:sellers, on_delete: :nothing)
      add :buyer_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:seller_id])
    create index(:orders, [:buyer_user_id])
    create unique_index(:orders, [:invoice_link])
  end
end
