defmodule FoodFromHome.Geocoding do
  @moduledoc """
  Module to manage the position of a deliverer on google maps
  """
  alias FoodFromHome.Users.User.Address

  @google_geocoding_api_key Application.compile_env(:food_from_home, GoogleGeocodingAPI)[:key]
  @google_geocoding_api_url "https://maps.googleapis.com/maps/api/geocode/json"

  def get_position(address = %Address{}) do
    address_string = address_to_string(address)

    position_request_url =
      "#{@google_geocoding_api_url}?address=#{address_string}&key=#{@google_geocoding_api_key}"

    case HTTPoison.get(position_request_url) do
      {:ok, %{body: body}} ->
        position =
          body
          |> Jason.decode!()
          |> Map.get("results", [])
          |> hd()
          |> Map.get("geometry", %{})
          |> Map.get("location", %{})
          |> location_to_postgis()

        {:ok, position}

      error ->
        error
    end
  end

  # The positions returned by this function will be used by the deliverer movement simulator module (built using genserver) to call put "/:order_id/delivery" endpoint at regular intervals to update delivery current position once the order status is :on_the_way.

  # def get_deliverer_positions(seller_address = %Address{}, buyer_address = %Address{}) do
  # start_position = get_position(seller_address)
  # end_position = get_position(buyer_address)
  # Generate and return a list of intermediate positions including the end position.
  # end

  defp address_to_string(%Address{
         door_number: door_number,
         street: street,
         city: city,
         country: country,
         postal_code: postal_code
       }) do
    door_number <> "," <> street <> "," <> city <> "," <> country <> "," <> postal_code <> "."
  end

  defp location_to_postgis(%{"lat" => latitude, "lng" => longitude}) do
    %Geo.Point{coordinates: {latitude, longitude}}
  end
end
