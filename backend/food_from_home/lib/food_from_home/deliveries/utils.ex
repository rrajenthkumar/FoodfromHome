defmodule FoodFromHome.Deliveries.Utils do
  @moduledoc """
  Utility functions related to Delivery context
  """
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.Orders
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def is_delivery_older_than_a_month?(%Delivery{delivered_at: delivered_at}) do
    {:ok, delivered_at} = DateTime.from_naive(delivered_at, "Etc/UTC")
    now = DateTime.utc_now()

    # To check if the difference is not more than 31 days
    DateTime.diff(delivered_at, now) >= 31 * 24 * 60 * 60
  end

  # Not used as of now
  def is_delivery_related_to_current_user?(
        %User{id: current_user_id, user_type: :deliverer},
        %Delivery{deliverer_user_id: deliverer_user_id}
      ) do
    deliverer_user_id === current_user_id
  end

  # Not used as of now
  def is_delivery_related_to_current_user?(
        %User{id: current_user_id, user_type: :seller},
        %Delivery{order_id: order_id}
      ) do
    %User{id: seller_user_id} =
      order_id
      |> Orders.get!()
      |> Users.get_seller_user_from_order!()

    seller_user_id === current_user_id
  end
end
