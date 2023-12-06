defmodule FoodFromHomeWeb.SellerJSON do
  alias FoodFromHome.FoodMenus.FoodMenu
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
  Renders a single seller with user and food menu details if available.
  """
  def show(%{seller: seller}) do
    %{data: data(seller)}
  end

  defp data(%Seller{seller_user: %User{} = seller_user, food_menus: food_menus} = seller) when is_list(food_menus) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      user: limited_data(seller_user),
      food_menus: for(food_menu <- food_menus, do: limited_data(food_menu))
    }
  end

  defp data(%Seller{} = seller) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction
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

  defp limited_data(%Seller{} = seller) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      user: limited_data(seller.seller_user)
    }
  end

  defp limited_data(%User{} = seller_user) do
    %{
      id: seller_user.id,
      address: data(seller_user.address),
      phone_number: seller_user.phone_number,
      email_id: seller_user.email_id,
      first_name: seller_user.first_name,
      gender: seller_user.gender,
      last_name: seller_user.last_name,
      profile_image: seller_user.profile_image
    }
  end

  defp limited_data(%FoodMenu{} = food_menu) do
    %{
      id: food_menu.id,
      menu_illustration: food_menu.menu_illustration,
      name: food_menu.name,
      price: food_menu.price,
      rebate: food_menu.rebate
    }
  end
end
