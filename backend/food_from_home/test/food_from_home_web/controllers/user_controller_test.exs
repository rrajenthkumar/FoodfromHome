defmodule FoodFromHomeWeb.UserControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.UsersFixtures

  alias FoodFromHome.Users.User

  @create_attrs %{
    address: %{},
    phone_number: "+4912345678956",
    email_id: "some email_id",
    first_name: "some first_name",
    gender: :male,
    last_name: "some last_name",
    user_type: :buyer
  }
  @update_attrs %{
    address: %{},
    phone_number: "+4912345678978",
    email_id: "some updated email_id",
    first_name: "some updated first_name",
    gender: :female,
    last_name: "some updated last_name",
    profile_image: "some updated profile_image",
    user_type: :seller,
    deleted: true
  }
  @invalid_attrs %{address: nil, phone_number: nil, email_id: nil, first_name: nil, gender: nil, last_name: nil, user_type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "address" => %{},
               "phone_number" => "+4912345678956",
               "email_id" => "some email_id",
               "first_name" => "some first_name",
               "gender" => "male",
               "last_name" => "some last_name",
               "profile_image" => nil,
               "user_type" => "buyer",
               "deleted" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "address" => %{},
               "phone_number" => "+49123456789578",
               "email_id" => "some updated email_id",
               "first_name" => "some updated first_name",
               "gender" => "female",
               "last_name" => "some updated last_name",
               "profile_image" => "some updated profile_image",
               "user_type" => "seller",
               "deleted" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
