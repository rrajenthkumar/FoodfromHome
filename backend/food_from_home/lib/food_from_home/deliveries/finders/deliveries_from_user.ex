defmodule FoodFromHome.Deliveries.Finders.DeliveriesFromUser do
  @moduledoc """
  Finder to find deliveries from a seller or deliverer user with applicable filters
  """
  import Ecto.Query, warn: false

  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Returns a list of related deliveries for a user of type :deliverer or :seller with applicable filters.

  ## Examples

    iex> list(%User{}, [])
    [%Delivery{}, ...]

  """

  def list(%User{id: deliverer_user_id, user_type: :deliverer}, filters) when is_list(filters) do
    query =
      from(delivery in Delivery,
        where: ^filters,
        where: delivery.deliverer_user_id == ^deliverer_user_id)

    Repo.all(query)
  end

  def list(%User{id: seller_user_id, user_type: :seller}, filters) when is_list(filters) do
    query =
      from(delivery in Delivery,
        join: order in assoc(delivery, :order),
        join: seller in assoc(order, :seller),
        join: user in assoc(seller, :deliverer_user),
        where: ^filters,
        where: user.id == ^seller_user_id)

    Repo.all(query)
  end
end
