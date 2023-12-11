defmodule FoodFromHomeWeb.SellerJSON do
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.Reviews
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @doc """
  Renders a list of sellers with limited details.
  """
  def index(%{sellers: sellers}) do
    %{data: for(seller <- sellers, do: limited_data(seller))}
  end

  @doc """
  Renders a single seller with user and available food menu details.
  """
  def show(%{seller: seller}) do
    %{data: data(seller)}
  end

  defp data(seller = %Seller{seller_user: %User{} = seller_user, food_menus: food_menus})
       when is_list(food_menus) do
    %{
      id: seller.id,
      nickname: seller.nickname,
      illustration: seller.illustration,
      introduction: seller.introduction,
      tax_id: seller.tax_id,
      average_rating: Reviews.get_average_rating_from_seller(seller),
      seller_user: data(seller_user),
      available_food_menus: for(food_menu <- food_menus, do: data(food_menu))
    }
  end

  defp data(seller_user = %User{}) do
    %{
      seller_user_id: seller_user.id,
      address: data(seller_user.address),
      phone_number: seller_user.phone_number,
      email_id: seller_user.email_id,
      first_name: seller_user.first_name,
      gender: seller_user.gender,
      last_name: seller_user.last_name,
      profile_image: seller_user.profile_image
    }
  end

  defp data(%FoodMenu{} = food_menu) do
    %{
      food_menu_id: food_menu.id,
      menu_illustration: food_menu.menu_illustration,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate
    }
  end

  defp data(address = %Address{}) do
    %{
      door_number: address.door_number,
      street: address.street,
      city: address.city,
      country: address.country,
      postal_code: address.postal_code
    }
  end

  defp limited_data(seller = %Seller{}) do
    %{
      id: seller.id,
      nickname: seller.nickname,
      illustration: seller.illustration,
      introduction: seller.introduction,
      average_rating: Reviews.get_average_rating_from_seller(seller)
    }
  end
end
