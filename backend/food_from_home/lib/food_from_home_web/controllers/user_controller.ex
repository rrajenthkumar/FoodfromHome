defmodule FoodFromHomeWeb.UserController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User.Address
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHome.Geocoding
  alias FoodFromHomeWeb.ErrorHandler

  action_fallback FoodFromHomeWeb.FallbackController

  def create(conn, %{"user" => attrs}) do
    attrs =
      attrs
      |> Utils.convert_map_string_keys_to_atoms()
      |> add_geoposition()

    with {:ok, %User{} = user} <- Users.create_user(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn = %{assigns: %{current_user: %User{id: current_user_id}}}, %{"user_id" => user_id}) do
    case user_id === current_user_id do
      true ->
        case Users.get_user(user_id) do
          %User{} = user ->
            render(conn, :show, user: user)

          nil ->
            ErrorHandler.handle_error(conn, :not_found, "User not found")
        end

      false ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not same as the current user"
        )
    end
  end

  def update(conn = %{assigns: %{current_user: %User{id: current_user_id}}}, %{
        "user_id" => user_id,
        "user" => %{"address" => _address} = attrs
      }) do
    case user_id === current_user_id do
      true ->
        case Users.get_user(user_id) do
          %User{} = user ->
            attrs =
              attrs
              |> Utils.convert_map_string_keys_to_atoms()
              |> add_geoposition()

            with {:ok, %User{} = updated_user} <- Users.update_user(user, attrs) do
              render(conn, :show, user: updated_user)
            end

          nil ->
            ErrorHandler.handle_error(conn, :not_found, "User not found")
        end

      false ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not same as the current user"
        )
    end
  end

  def update(conn = %{assigns: %{current_user: %User{id: current_user_id}}}, %{
        "user_id" => user_id,
        "user" => attrs
      }) do
    case user_id === current_user_id do
      true ->
        case Users.get_user(user_id) do
          %User{} = user ->
            attrs = Utils.convert_map_string_keys_to_atoms(attrs)

            with {:ok, %User{} = updated_user} <- Users.update_user(user, attrs) do
              render(conn, :show, user: updated_user)
            end

          nil ->
            ErrorHandler.handle_error(conn, :not_found, "User not found")
        end

      false ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not same as the current user"
        )
    end
  end

  def delete(conn = %{assigns: %{current_user: %User{id: current_user_id}}}, %{
        "user_id" => user_id
      }) do
    case user_id === current_user_id do
      true ->
        case Users.get_user(user_id) do
          %User{} = user ->
            with {:ok, %User{} = _soft_deleted_user} <- Users.soft_delete_user(user) do
              send_resp(conn, :no_content, "")
            end

          nil ->
            ErrorHandler.handle_error(conn, :not_found, "User not found")
        end

      false ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "User is not same as the current user"
        )
    end
  end

  defp add_geoposition(attrs) when is_map(attrs) do
    address = Map.get(attrs, :address)

    geoposition =
      Address
      |> struct!(address)
      |> Geocoding.get_position()

    Map.put(attrs, :geoposition, geoposition)
  end
end
