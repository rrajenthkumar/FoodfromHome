defmodule FoodFromHomeWeb.SellerJSON do
  alias FoodFromHome.Sellers.Seller

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

  defp data(%Seller{user: %User{} = user, food_menus: food_menus} = seller) when is_list(food_menus) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      user: limited_data(user),
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

  defp limited_data(%Seller{} = seller) do
    %{
      id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      user: limited_data(seller.user)
    }
  end

  defp limited_data(%User{} = user) do
    %{
      id: user.id,
      address: data(user.address),
      phone_number: user.phone_number,
      email_id: user.email_id,
      first_name: user.first_name,
      gender: user.gender,
      last_name: user.last_name,
      profile_image: user.profile_image
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
