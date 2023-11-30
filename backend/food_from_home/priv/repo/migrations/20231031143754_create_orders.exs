defmodule FoodFromHome.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :delivery_address, :map, default: nil
      add :status, :string, default: "open"
      add :invoice_link, :string, default: nil
      add :seller_remark, :string, default: nil
      add :seller_id, references(:sellers, on_delete: :nothing)
      add :buyer_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:seller_id])
    create index(:orders, [:buyer_user_id])
    create unique_index(:orders, [:invoice_link])
    create unique_index(:orders, [:buyer_id], where: "status = 'open'", name: :unique_open_order_per_buyer_index)
  end
end
