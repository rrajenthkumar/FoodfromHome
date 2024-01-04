defmodule FoodFromHomeWeb.UserController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  @keys_of_atom_type_fields_for_create [:gender, :user_type]

  @keys_of_atom_type_fields_for_update [:gender]

  def create(conn, %{
        "user" => attrs
      }) do
    attrs =
      attrs
      |> Utils.convert_string_keys_to_atoms()
      |> Utils.convert_string_values_to_atoms(@keys_of_atom_type_fields_for_create)

    with {:ok, %User{} = user} <-
           Users.create_auth0_user_and_get_geoposition_and_create_user_resource(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{
        "user_id" => user_id,
        "user" => %{"address" => _address} = attrs
      }) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      attrs =
        attrs
        |> Utils.convert_string_keys_to_atoms()
        |> Utils.convert_string_values_to_atoms(@keys_of_atom_type_fields_for_update)

      with {:ok, %User{} = updated_user} <-
             Users.get_updated_geoposition_and_update_user(user, attrs) do
        render(conn, :show, user: updated_user)
      end
    end
  end

  def update(conn, %{
        "user_id" => user_id,
        "user" => attrs
      }) do
    with {:ok, %User{} = user} <- run_preliminary_checks(conn, user_id) do
      attrs =
        attrs
        |> Utils.convert_string_keys_to_atoms()
        |> Utils.convert_string_values_to_atoms(@keys_of_atom_type_fields_for_update)

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
