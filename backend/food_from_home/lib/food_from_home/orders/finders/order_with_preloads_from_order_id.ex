defmodule FoodFromHome.Orders.Finders.OrderWithPreloadsFromOrderId do
  @moduledoc """
  Finder to find an order from order_id with seller user, buyer user, deliverer user, cart items, food menus, delivery and review preloads
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Repo

  @doc """
  Finds an order from order_id with seller, seller user, buyer user, deliverer user, cart items, food menus, delivery and review preloads

  Returns 'nil' if the order does not exist.

  ## Examples

      iex> find(123)
      %Order{}

      iex> find(456)
      nil

  """
  def find(order_id) when is_integer(order_id) do
    query =
      from(order in Order,
        join: seller in assoc(order, :seller),
        join: seller_user in assoc(seller, :seller_user),
        join: buyer_user in assoc(order, :buyer_user),
        join: cart_item in assoc(order, :cart_items),
        join: food_menu in assoc(cart_item, :food_menu),
        join: delivery in assoc(order, :delivery),
        join: deliverer_user in assoc(delivery, :deliverer_user),
        join: review in assoc(order, :review),
        where: order.id == ^order_id,
        preload: [
          seller: {seller, seller_user: seller_user},
          buyer_user: buyer_user,
          cart_items: {cart_item, food_menu: food_menu},
          delivery: {delivery, deliverer_user: deliverer_user},
          review: review
        ]
      )

    Repo.one(query)
  end
end
