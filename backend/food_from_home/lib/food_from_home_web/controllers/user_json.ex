defmodule FoodFromHomeWeb.UserJSON do
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.User.Address

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user = %User{user_type: :seller}) do
    %{
      id: user.id,
      address: data(user.address),
      geoposition: data(user.geoposition),
      phone_number: user.phone_number,
      email_id: user.email_id,
      first_name: user.first_name,
      gender: user.gender,
      last_name: user.last_name,
      profile_image: user.profile_image,
      user_type: user.user_type,
      seller: data(user.seller)
    }
  end

  defp data(user = %User{}) do
    %{
      id: user.id,
      address: data(user.address),
      geoposition: data(user.geoposition),
      phone_number: user.phone_number,
      email_id: user.email_id,
      first_name: user.first_name,
      gender: user.gender,
      last_name: user.last_name,
      profile_image: user.profile_image,
      user_type: user.user_type
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

  defp data(%Geo.Point{coordinates: {latitude, longitude}}) do
    %{
      latitude: latitude,
      longitude: longitude
    }
  end

  defp data(seller = %Seller{}) do
    %{
      seller_id: seller.id,
      illustration: seller.illustration,
      introduction: seller.introduction,
      tax_id: seller.tax_id
    }
  end
end
