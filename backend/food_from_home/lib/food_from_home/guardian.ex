defmodule FoodFromHome.Guardian do
  use Guardian, otp_app: :food_from_home

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Users.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
