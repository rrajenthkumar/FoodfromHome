defmodule FoodFromHomeWeb.UserController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn, %{"user" => attrs}) do
    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

    with {:ok, %User{} = user} <- Users.get_geoposition_and_create_user(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    with {:ok, %User{} = user} <- preliminary_check_result(conn, user_id) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{
        "user_id" => user_id,
        "user" => %{"address" => _address} = attrs
      }) do
    with {:ok, %User{} = user} <- preliminary_check_result(conn, user_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

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
    with {:ok, %User{} = user} <- preliminary_check_result(conn, user_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %User{} = updated_user} <- Users.update_user(user, attrs) do
        render(conn, :show, user: updated_user)
      end
    end
  end

  def delete(conn, %{
        "user_id" => user_id
      }) do
    with {:ok, %User{} = user} <- preliminary_check_result(conn, user_id) do
      with {:ok, %User{} = _soft_deleted_user} <- Users.soft_delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  defp preliminary_check_result(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         user_id
       )
       when is_integer(user_id) do
    user_result = Users.get_user(user_id)

    cond do
      is_nil(user_result) ->
        ErrorHandler.handle_error(conn, :not_found, "User not found")

      user_is_not_current_user?(user_result, current_user) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not the current user"
        )

      true ->
        {:ok, user_result}
    end
  end

  defp user_is_not_current_user?(%User{id: current_user_id}, %User{id: user_id}) do
    current_user_id !== user_id
  end
end
