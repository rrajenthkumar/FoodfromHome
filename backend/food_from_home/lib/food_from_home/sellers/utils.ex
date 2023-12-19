defmodule FoodFromHome.Sellers.Utils do
  @moduledoc """
  Utility functions related to Seller context
  """
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  def seller_belongs_to_user?(
        %Seller{
          seller_user_id: seller_user_id
        },
        %User{id: user_id}
      ) do
    seller_user_id === user_id
  end

  def seller_does_not_belong_to_user?(
        %Seller{
          seller_user_id: seller_user_id
        },
        %User{id: user_id}
      ) do
    seller_user_id !== user_id
  end
end
