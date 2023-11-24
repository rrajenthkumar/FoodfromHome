defmodule FoodFromHome.FoodMenus.FoodMenu do
  use Ecto.Schema
  import Ecto.Changeset

  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.FoodMenus.FoodMenu.Rebate
  alias FoodFromHome.Repo
  alias FoodFromHome.Sellers.Seller

  @allowed_create_keys [:seller_id, :name, :description, :menu_illustration, :ingredients, :allergens, :price, :rebate, :valid_until, :preparation_time_in_minutes, :remaining_quantity]
  @required_keys [:seller_id, :name, :description, :menu_illustration, :ingredients, :price, :valid_until, :preparation_time_in_minutes, :remaining_quantity]
  @allowed_update_keys [:name, :description, :menu_illustration, :ingredients, :allergens, :price, :rebate, :valid_until, :preparation_time_in_minutes, :remaining_quantity]

  schema "food_menus" do
    field :name, :string
    field :description, :string
    field :menu_illustration, :binary
    field :ingredients, {:array, :string}
    field :allergens, {:array, :string}, default: []
    field :price, :decimal
    field :rebate, :map, default: nil
    field :valid_until, :utc_datetime
    field :preparation_time_in_minutes, :integer
    field :remaining_quantity, :integer

    embeds_one :rebate, Rebate, on_replace: :update do
      field :count, :integer
      field :discount_percentage, :decimal
    end

    belongs_to :seller, Seller
    has_many :cart_items, CartItem

    timestamps()
  end

  @doc """
  Changeset for new food menu record creation
  """
  def create_changeset(food_menu, attrs) do
    food_menu
    |> cast(attrs, @allowed_create_keys)
    |> validate_required(@required_keys)
    |> unique_constraint(:seller_id_name_valid_until_constraint, name: :seller_id_name_valid_until_index)
    |> foreign_key_constraint(:seller_id)
    |> cast_embed(:rebate, with: &rebate_changeset/2)
  end

  @doc """
  Changeset for updating an existing food menu record
  """
  def update_changeset(food_menu, attrs) do
    food_menu
    |> cast(attrs, @allowed_update_keys)
    |> validate_required(@required_keys)
    |> validate_no_associated_cart_items()
    |> unique_constraint(:seller_id_name_valid_until_constraint, name: :seller_id_name_valid_until_index)
    |> foreign_key_constraint(:seller_id)
    |> cast_embed(:rebate, with: &rebate_changeset/2)
  end

  @doc """
  Changeset function for Rebate schema.
  """
  def rebate_changeset(rebate = %Rebate{}, attrs = %{}) do
    address
    |> cast(attrs, [:count, :discount_percentage])
    |> validate_required([:count, :discount_percentage])
  end

  defp validate_no_associated_cart_items(changeset = %Ecto.Changeset{data: %FoodMenu{} = food_menu}) do
    cart_item_count = Repo.aggregate(from cart_item in CartItem, where: cart_item.food_menu_id == ^food_menu.id, select: count(cart_item.id))
      if cart_item_count > 0 do
        add_error(changeset, :base, "Cannot update a food menu with an associated order.")
      else
        changeset
      end
  end
end
