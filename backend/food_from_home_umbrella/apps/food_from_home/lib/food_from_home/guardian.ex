defmodule FoodFromHome.Guardian do
  use Guardian, otp_app: :food_from_home

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def subject_for_token(_resource = %User{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(_claims = %{"sub" => id}) do
    resource =
      id
      |> String.to_integer()
      |> Users.get_user!()

    {:ok, resource}
  rescue
    Ecto.NoResultsError -> {:error, "No user resource found corresponding to the JWT claim"}
  end
end
