defmodule FoodFromHomeWeb.UserController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Auth0Management
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn, %{
        "user" =>
          %{
            "gender" => gender,
            "user_type" => user_type,
            "email" => email,
            "password" => password
          } = attrs
      }) do
    user_type = String.to_existing_atom(user_type)
    gender = String.to_existing_atom(gender)

    attrs =
      attrs
      |> Utils.convert_map_string_keys_to_atoms()
      |> Map.replace(:user_type, user_type)
      |> Map.replace(:gender, gender)
      |> Map.drop(:password)

    with {:ok, %User{} = user} <- Users.get_geoposition_and_create_user(attrs) do
      case Auth0Management.create_user(email, password) do
        {:ok, _auth0_response} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/v1/users/#{user.id}")
          |> render(:show, user: user)

        {:error, reason} ->
          with {:ok, %User{} = _deleted_user} <- Users.delete_user(user) do
            ErrorHandler.handle_error(
              conn,
              :internal_server_error,
              "Unable to create an auth0 user. Reason: #{reason}"
            )
          end
      end
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{
        "user_id" => user_id,
        "user" => %{"gender" => gender, "address" => _address} = attrs
      }) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      gender = String.to_existing_atom(gender)

      attrs =
        attrs
        |> Utils.convert_map_string_keys_to_atoms()
        |> Map.replace(:gender, gender)

      with {:ok, %User{} = updated_user} <-
             Users.get_updated_geoposition_and_update_user(user, attrs) do
        render(conn, :show, user: updated_user)
      end
    end
  end

  def update(conn, %{
        "user_id" => user_id,
        "user" => %{"gender" => gender} = attrs
      }) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      gender = String.to_existing_atom(gender)

      attrs =
        attrs
        |> Utils.convert_map_string_keys_to_atoms()
        |> Map.replace(:gender, gender)

      with {:ok, %User{} = updated_user} <- Users.update_user(user, attrs) do
        render(conn, :show, user: updated_user)
      end
    end
  end

  def delete(conn, %{
        "user_id" => user_id
      }) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      with {:ok, %User{} = _soft_deleted_user} <- Users.soft_delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  defp run_preliminary_checks(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         user_id
       )
       when is_integer(user_id) do
    user_result = Users.get_user(user_id)

    cond do
      is_nil(user_result) ->
        ErrorHandler.handle_error(conn, :not_found, "User not found")

      user_result.id === current_user.id ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not the current user"
        )

      true ->
        {:ok, user_result}
    end
  end
end
