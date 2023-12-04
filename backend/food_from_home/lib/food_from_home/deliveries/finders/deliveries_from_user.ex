defmodule FoodFromHome.Deliveries.Finders.DeliveriesFromUser do
  @moduledoc """
  Finder to list deliveries linked to seller or deliverer user
  """
  import Ecto.Query, warn: false

  @doc """
  Returns a list of deliveries linked to a seller or deliverer user, after applying given filters.
  ## Examples

    iex> find(%User{}, %{})
    [%Delivery{}, ...]

  """

  alias FoodFromHome.Repo
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils

  def find(user = %User{}, filter_params = %{} \\ %{}) do
    filter_params
    |> Utils.convert_map_to_keyword_list()
    |> build_query(user)
    |> Repo.all()
  end

  defp build_query(filters, %User{user_type: :deliverer, id: deliverer_user_id}) when is_list(filters) do
    from(delivery in Delivery,
      where: delivery.deliverer_user_id == ^deliverer_user_id,
      where: ^filters)
  end

  defp build_query(filters, %User{user_type: :seller, id: seller_user_id}) when is_list(filters) do
    from(delivery in Delivery,
      join: order in assoc(delivery, :orders),
      join: seller in assoc(order, :sellers),
      where: seller.user_id == ^seller_user_id,
      where: ^filters)
  end
end
