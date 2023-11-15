defmodule FoodFromHome.Users.UserRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.UserRepoFixtures

  @valid_attrs %{address: %{door_number: "1", street: "Mehringweg", city: "Berlin", country: "Germany", postal_code: "77777"}, phone_number: "+4912345678912", email_id: "new@email.de", first_name: "some first_name", gender: :male, last_name: "some last_name", user_type: :buyer}

  @valid_attrs_with_seller_data %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :seller, seller: %{introduction: "some random introduction", illustration: "some random illustration", tax_id: "xyz12345678"}}

  @valid_update_attrs %{address: %{door_number: "11B", street: "ABC Street", city: "London", country: "United Kingdom", postal_code: "98765"}, phone_number: "+4912345678934", email_id: "updated@email.de"}

  @attrs_with_invalid_user_data %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: nil, email_id: nil, first_name: nil, gender: nil, last_name: nil, user_type: nil}

  @attrs_with_invalid_address_data %{address: %{door_number: nil, street: nil, city: nil, country: nil, postal_code: nil}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :buyer}

  @attrs_with_invalid_seller_data %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :seller, seller: %{introduction: nil, illustration: nil, tax_id: nil}}

  setup do
    user = UserRepoFixtures.user_fixture()
    %{user: user}
  end

  describe "create_user/1" do

    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = UserRepo.create_user(@valid_attrs)

      assert user.address.door_number == "1"
      assert user.address.street == "Mehringweg"
      assert user.address.city == "Berlin"
      assert user.address.country == "Germany"
      assert user.address.postal_code == "77777"
      assert user.phone_number == "+4912345678912"
      assert user.email_id == "new@email.de"
      assert user.first_name == "some first_name"
      assert user.gender == :male
      assert user.last_name == "some last_name"
      assert user.profile_image == nil
      assert user.user_type == :buyer
      assert user.deleted == false

      assert UserRepo.get_user!(user.id) == user
    end

    test "valid data of user_type ':seller' creates a user and also a corresponding seller" do
      assert {:ok, %User{seller: %Seller{} = seller} = user} = UserRepo.create_user(@valid_attrs_with_seller_data)

      assert user.address.door_number == "2"
      assert user.address.street == "Postweg"
      assert user.address.city == "Munich"
      assert user.address.country == "Germany"
      assert user.address.postal_code == "666555"
      assert user.phone_number == "+4912344321545"
      assert user.email_id == "random@email.de"
      assert user.first_name == "some random first_name"
      assert user.gender == :female
      assert user.last_name == "some random last_name"
      assert user.profile_image == "some random profile image"
      assert user.user_type == :seller
      assert user.deleted == false
      assert seller.introduction == "some random introduction"
      assert seller.illustration == "some random illustration"
      assert seller.tax_id == "xyz12345678"

      assert UserRepo.get_user!(user.id) |> Repo.preload(:seller) == user
      assert Sellers.get_seller!(seller.id) == seller
    end

    test "with invalid user data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@attrs_with_invalid_user_data)
    end

    test "with invalid address data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@attrs_with_invalid_address_data)
    end

    test "with invalid seller data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@attrs_with_invalid_seller_data)
    end
  end

  describe "get_user!/1" do
    test "returns the user with given id", %{user: user} do
      assert UserRepo.get_user!(user.id) == user
    end

    test "returns Ecto.NoResultsError error when the user is not found", %{user: user} do
      assert_raise Ecto.NoResultsError, fn -> UserRepo.get_user!(user.id + 1) end
    end
  end

  describe "update_user/2" do
    test "with valid data updates the user", %{user: user} do
      assert {:ok, %User{} = updated_user} = UserRepo.update_user(user, @valid_update_attrs)

      assert updated_user.address.door_number == "11B"
      assert updated_user.address.street == "ABC Street"
      assert updated_user.address.city == "London"
      assert updated_user.address.country == "United Kingdom"
      assert updated_user.address.postal_code == "98765"
      assert updated_user.phone_number == "+4912345678934"
      assert updated_user.email_id == "updated@email.de"

      assert UserRepo.get_user!(user.id) == updated_user
    end

    test "with user_type update returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = UserRepo.update_user(user, %{user_type: :deliverer})

      assert UserRepo.get_user!(user.id) == user
    end

    test "with invalid data returns error changeset", %{user: user}  do
      assert {:error, %Ecto.Changeset{}} = UserRepo.update_user(user, @attrs_with_invalid_user_data)

      assert UserRepo.get_user!(user.id) == user
    end
  end


  test "soft_delete_user/1 updates 'deleted' field to 'true' and returns the user", %{user: user} do
    assert {:ok, %User{} = soft_deleted_user} = UserRepo.soft_delete_user(user)

    assert soft_deleted_user.deleted == true
    assert UserRepo.get_user!(user.id) == soft_deleted_user
  end

  describe "list_users/1" do
    setup do
      user_2 = UserRepoFixtures.user_fixture(%{user_type: :deliverer})
      %{user_2: user_2}
    end

    test "returns all users when filter params is empty", %{user: user_1, user_2: user_2} do
      assert UserRepo.list_users() == [user_1, user_2]
    end

    test "returns only not soft deleted users when 'include_deleted' filter is not set to 'true", %{user: user_1, user_2: user_2} do
      {:ok, %User{} = _soft_deleted_user_2} = UserRepo.soft_delete_user(user_2)

      assert UserRepo.list_users() == [user_1]
    end

    test "returns soft deleted users too when 'include_deleted' filter is set to 'true", %{user: user_1, user_2: user_2} do
      {:ok, %User{} = soft_deleted_user_2} = UserRepo.soft_delete_user(user_2)

      assert UserRepo.list_users(%{include_deleted: "true"}) == [user_1, soft_deleted_user_2]
    end

    test "returns users based on combination of filter params", %{user: _user_1, user_2: user_2} do
      user_3 = UserRepoFixtures.user_fixture(%{user_type: :deliverer})
      {:ok, %User{} = _soft_deleted_user_3} = UserRepo.soft_delete_user(user_3)

      _user_4 = UserRepoFixtures.user_fixture_for_seller_type()



      assert UserRepo.list_users(%{user_type: "deliverer", include_deleted: "false"}) == [user_2]
    end
  end

  test "change_create_user/1 returns a user changeset", %{user: user} do
    assert %Ecto.Changeset{} = UserRepo.change_create_user(user)
  end

  test "change_update_user/1 returns a user changeset", %{user: user} do
    assert %Ecto.Changeset{} = UserRepo.change_update_user(user)
  end
end
