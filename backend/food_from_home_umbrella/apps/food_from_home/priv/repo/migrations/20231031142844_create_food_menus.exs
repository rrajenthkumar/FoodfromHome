defmodule FoodFromHome.Repo.Migrations.CreateFoodMenus do
  use Ecto.Migration

  def change do
    create table(:food_menus) do
      add :name, :string
      add :description, :text
      add :ingredients, {:array, :string}
      add :allergens, {:array, :string}, default: []
      add :price, :decimal
      add :rebate, :map, default: nil
      add :menu_illustration, :binary
      add :preparation_time_in_minutes, :integer
      add :valid_until, :utc_datetime
      add :seller_id, references(:sellers, on_delete: :nothing)
      add :remaining_quantity, :integer

      timestamps()
    end

    create index(:food_menus, [:seller_id])

    execute(
      "CREATE UNIQUE INDEX unique_food_menu_name_per_seller_per_validity_date_index ON food_menus (seller_id, name, DATE(valid_until));"
    )
  end
end
