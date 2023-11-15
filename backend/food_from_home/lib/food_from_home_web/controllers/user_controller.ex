defmodule FoodFromHomeWeb.UserController do
  use FoodFromHomeWeb, :controller

  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  action_fallback FoodFromHomeWeb.FallbackController

  def index(conn, filter_params = %{}) do
    users = Users.list_users(filter_params)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    user = Users.get_user!(user_id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"user_id" => user_id, "user" => user_params}) do
    user = Users.get_user!(user_id)
    with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: updated_user)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    user = Users.get_user!(user_id)
    with {:ok, %User{} = _soft_deleted_user} <- Users.soft_delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
