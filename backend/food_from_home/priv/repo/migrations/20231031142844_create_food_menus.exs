defmodule FoodFromHome.Repo.Migrations.CreateFoodMenus do
  use Ecto.Migration

  def change do
    create table(:food_menus) do
      add :name, :string
      add :description, :text
      add :ingredients, :string
      add :allergens, :string
      add :price, :decimal
      add :rebate, :map
      add :menu_illustration, :binary
      add :preparation_time_in_minutes, :integer
      add :valid_until, :utc_datetime
      add :seller_id, references(:sellers, on_delete: :nothing)

      timestamps()
    end

    create index(:food_menus, [:seller_id])
  end
end
