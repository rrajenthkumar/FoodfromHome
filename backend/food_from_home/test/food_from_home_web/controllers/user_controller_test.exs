defmodule FoodFromHomeWeb.UserControllerTest do
  use FoodFromHomeWeb.ConnCase

  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.UserRepoFixtures

  @create_attrs %{
    address: %{door_number: "5", street: "Moorstraße", city: "Frankfurt", country: "Germany", postal_code: "845789"},
    phone_number: "+4912334578912",
    email_id: "random@email.de",
    first_name: "random first_name",
    gender: :non_binary,
    last_name: "random last_name",
    user_type: :buyer
  }

  @create_attrs_with_seller_data %{
    address: %{door_number: "10", street: "Alter Postweg", city: "Dortmund", country: "Germany", postal_code: "457814"},
    phone_number: "+4912334578534",
    email_id: "another_random@email.de",
    first_name: "another random first_name",
    gender: :female,
    last_name: "another random last_name",
    user_type: :seller,
    seller: %{introduction: "random introduction", tax_id: "xyz12345678"}
  }

  @update_attrs %{
    address: %{door_number: "10", street: "Moorburgerstraße", city: "Bremen", country: "Germany", postal_code: "789456"},
    phone_number: "+491231118912",
    email_id: "updated@email.de",
    first_name: "updated first_name",
    gender: :female,
    last_name: "updated last_name",
    profile_image: "updated profile image"
  }

  @invalid_attrs %{address: nil, phone_number: nil, email_id: nil, first_name: nil, gender: nil, last_name: nil, user_type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users (excluding soft deleted ones)", %{conn: conn} do
      user_1 = UserRepoFixtures.user_fixture()
      user_2 = UserRepoFixtures.user_fixture()
      {:ok, %User{} = _soft_deleted_user_2} = UserRepo.soft_delete_user(user_2)

      conn = get(conn, ~p"/api/v1/users")

      assert json_response(conn, 200)["data"] == [
        %{"id" => user_1.id,
          "email_id" => user_1.email_id,
          "first_name" => user_1.first_name,
          "gender" => to_string(user_1.gender),
          "last_name" => user_1.last_name,
          "address" => %{"city" => user_1.address.city,
            "country" => user_1.address.country,
            "door_number" => user_1.address.door_number,
            "postal_code" => user_1.address.postal_code,
            "street" => user_1.address.street},
          "phone_number" => user_1.phone_number,
          "profile_image" => user_1.profile_image,
          "user_type" => to_string(user_1.user_type)}
      ]
    end

    test "lists users filtered based on query parameters", %{conn: conn} do
      _user_1 = UserRepoFixtures.user_fixture() # user_1 is of type :buyer by default
      user_2 = UserRepoFixtures.user_fixture(%{user_type: :deliverer})
      {:ok, %User{} = user_3} =
        %{user_type: :deliverer}
        |> UserRepoFixtures.user_fixture()
        |> UserRepo.soft_delete_user()

      conn = get(conn, ~p"/api/v1/users?user_type=deliverer&include_deleted=true")

      assert json_response(conn, 200)["data"] == [
        %{"id" => user_2.id,
          "email_id" => user_2.email_id,
          "first_name" => user_2.first_name,
          "gender" => to_string(user_2.gender),
          "last_name" => user_2.last_name,
          "address" => %{"city" => user_2.address.city,
            "country" => user_2.address.country,
            "door_number" => user_2.address.door_number,
            "postal_code" => user_2.address.postal_code,
            "street" => user_2.address.street},
          "phone_number" => user_2.phone_number,
          "profile_image" => user_2.profile_image,
          "user_type" => "deliverer"},
          %{"id" => user_3.id,
          "email_id" => user_3.email_id,
          "first_name" => user_3.first_name,
          "gender" => to_string(user_3.gender),
          "last_name" => user_3.last_name,
          "address" => %{"city" => user_3.address.city,
            "country" => user_3.address.country,
            "door_number" => user_3.address.door_number,
            "postal_code" => user_3.address.postal_code,
            "street" => user_3.address.street},
          "phone_number" => user_3.phone_number,
          "profile_image" => user_3.profile_image,
          "user_type" => "deliverer"}
      ]
    end
  end

  describe "create" do
    test "creates and renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/users", user: @create_attrs)

      %{"id" => user_id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/users/#{user_id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => user_id,
               "address" => %{"door_number" => "5", "street" => "Moorstraße", "city" => "Frankfurt", "country" => "Germany", "postal_code" => "845789"},
               "phone_number" => "+4912334578912",
               "email_id" => "random@email.de",
               "first_name" => "random first_name",
               "gender" => "non_binary",
               "last_name" => "random last_name",
               "profile_image" => nil,
               "user_type" => "buyer"
             }
    end


    test "creates user, seller and renders user when data is valid for seller user type", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/users", user: @create_attrs_with_seller_data)

      %{"id" => user_id, "seller" => %{"id" => seller_id, "link" => seller_route}} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/users/#{user_id}")

      assert json_response(conn, 200)["data"] == %{
               "id" => user_id,
               "address" => %{"door_number" => "10", "street" => "Alter Postweg", "city" => "Dortmund", "country" => "Germany", "postal_code" => "457814"},
               "phone_number" => "+4912334578534",
               "email_id" => "another_random@email.de",
               "first_name" => "another random first_name",
               "gender" => "female",
               "last_name" => "another random last_name",
               "profile_image" => nil,
               "user_type" => "seller",
               "seller" => %{
                  "id" =>  seller_id,
                  "link" => seller_route
                }
              }

      conn = get(conn, ~p"/api/v1/sellers/#{seller_id}")

      assert json_response(conn, 200)["data"] == %{
        "id" => seller_id,
        "introduction" => "random introduction",
        "tax_id" => "xyz12345678",
        "illustration" => nil
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show" do
    test "gets an user", %{conn: conn} do
      user = UserRepoFixtures.user_fixture()

      conn = get(conn, ~p"/api/v1/users/#{user.id}")

      assert json_response(conn, 200)["data"] == %{
        "id" => user.id,
          "email_id" => user.email_id,
          "first_name" => user.first_name,
          "gender" => to_string(user.gender),
          "last_name" => user.last_name,
          "address" => %{"city" => user.address.city,
            "country" => user.address.country,
            "door_number" => user.address.door_number,
            "postal_code" => user.address.postal_code,
            "street" => user.address.street},
          "phone_number" => user.phone_number,
          "profile_image" => user.profile_image,
          "user_type" => to_string(user.user_type)
        }
    end

    test "gets an user of type seller", %{conn: conn} do
      user = UserRepoFixtures.user_fixture_for_seller_type()

      conn = get(conn, ~p"/api/v1/users/#{user.id}")

      seller_route = "/sellers/#{user.seller.id}"

      assert json_response(conn, 200)["data"] == %{
          "id" => user.id,
          "email_id" => user.email_id,
          "first_name" => user.first_name,
          "gender" => to_string(user.gender),
          "last_name" => user.last_name,
          "address" => %{"city" => user.address.city,
            "country" => user.address.country,
            "door_number" => user.address.door_number,
            "postal_code" => user.address.postal_code,
            "street" => user.address.street},
          "phone_number" => user.phone_number,
          "profile_image" => user.profile_image,
          "user_type" => to_string(user.user_type),
          "seller" => %{
            "id" =>  user.seller.id,
            "link" => seller_route
          }
        }
    end
  end

  describe "update" do
    setup do
      user = UserRepoFixtures.user_fixture()

      %{user: user}
    end

    test "updates and renders user when data is valid", %{conn: conn, user: %User{id: user_id}} do
      conn = put(conn, ~p"/api/v1/users/#{user_id}", user: @update_attrs)

      assert  json_response(conn, 200)["data"] == %{
        "id" => user_id,
        "address" => %{"door_number" => "10", "street" => "Moorburgerstraße", "city" => "Bremen", "country" => "Germany", "postal_code" => "789456"},
        "phone_number" => "+491231118912",
        "email_id" => "updated@email.de",
        "first_name" => "updated first_name",
        "gender" => "female",
        "last_name" => "updated last_name",
        "profile_image" => "updated profile image",
        "user_type" => "buyer"
      }

      conn = get(conn, ~p"/api/v1/users/#{user_id}")

      assert  json_response(conn, 200)["data"] == %{
               "id" => user_id,
               "address" => %{"door_number" => "10", "street" => "Moorburgerstraße", "city" => "Bremen", "country" => "Germany", "postal_code" => "789456"},
               "phone_number" => "+491231118912",
               "email_id" => "updated@email.de",
               "first_name" => "updated first_name",
               "gender" => "female",
               "last_name" => "updated last_name",
               "profile_image" => "updated profile image",
               "user_type" => "buyer"
             }
    end

    test "renders error in case of user_type field update", %{conn: conn, user: %User{id: user_id}} do
      conn = put(conn, ~p"/api/v1/users/#{user_id}", user: %{user_type: :deliverer})

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error in case of deleted field update", %{conn: conn, user: %User{id: user_id}} do
      conn = put(conn, ~p"/api/v1/users/#{user_id}", user: %{deleted: true})

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, user: %User{id: user_id}} do
      conn = put(conn, ~p"/api/v1/users/#{user_id}", user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  test "delete/1 (soft) deletes chosen user", %{conn: conn} do

    user = UserRepoFixtures.user_fixture()

    assert user.deleted == false

    conn = delete(conn, ~p"/api/v1/users/#{user.id}")

    assert response(conn, 204)

    soft_deleted_user = UserRepo.get_user!(user.id)

    assert soft_deleted_user.deleted == true
  end
end
