defmodule FoodFromHome.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items) do
      add :count, :integer
      add :remark, :text, default: nil
      add :order_id, references(:orders, on_delete: :delete_all)
      add :food_menu_id, references(:food_menus, on_delete: :nothing)

      timestamps()
    end

    create index(:cart_items, [:order_id])
    create index(:cart_items, [:food_menu_id])

    create unique_index(:cart_items, [:order_id, :food_menu_id],
             name: :unique_food_menu_id_order_id_combo_index
           )
  end
end
