defmodule FoodFromHome.Users.UserRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Users.UserRepo
  alias FoodFromHome.Users.UserRepoFixtures

    @invalid_attrs %{address: %{door_number: nil, street: nil, city: nil, country: nil, postal_code: nil}, phone_number: nil, email_id: nil, first_name: nil, gender: nil, last_name: nil, user_type: nil}

    setup do
      user = UserRepoFixtures.user_fixture()
      %{user: user}
    end

    test "get_user!/1 returns the user with given id", %{user: user} do

      assert UserRepo.get_user!(user.id) == user
    end

    test "get_active_user_from_email_id!/1 returns the active user with given email id", %{user: user_1} do

      #Creating another user 'user_2' and updating it with same email id as 'user_1' and marking it as 'deleted'
      user_2 = UserRepoFixtures.user_fixture()
      {:ok, _updated_user_2} = UserRepo.update_user(user_2.id, %{email: user_1.email_id, deleted: true})

      assert UserRepo.get_active_user_from_email_id!(user_1.email_id) == user_1
    end

    describe "create_user/1" do

      test "with valid data creates a user" do
        valid_attrs = %{address: %{door_number: "1", street: "Mehringweg", city: "Berlin", country: "Germany", postal_code: "77777"}, phone_number: "+4912345678912", email_id: "new@email.de", first_name: "some first_name", gender: :male, last_name: "some last_name", user_type: :buyer}

        assert {:ok, %User{} = user} = UserRepo.create_user(valid_attrs)

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

      test "valid data with user_type ':seller' creates a user and a corresponding seller" do
        valid_attrs = %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :seller, seller: %{introduction: "some random introduction", illustration: "some random illustration", tax_id: "xyz12345678"}}

        assert {:ok, %User{seller: %Seller{} = seller} = user} = UserRepo.create_user(valid_attrs)

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

      test "valid data with user_type ':seller' but without 'any' seller related info returns error changeset" do
        valid_attrs = %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :seller}

        assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(valid_attrs)
      end

      test "valid data with user_type ':seller' but without all 'required' seller related info returns error changeset" do
        valid_attrs = %{address: %{door_number: "2", street: "Postweg", city: "Munich", country: "Germany", postal_code: "666555"}, phone_number: "+4912344321545", email_id: "random@email.de", first_name: "some random first_name", gender: :female, last_name: "some random last_name", profile_image: "some random profile image", user_type: :seller, seller: %{introduction: "some random introduction"}}

        assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(valid_attrs)
      end

      test "with invalid data returns error changeset" do
        assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@invalid_attrs)
      end
    end

  describe "update_user/2" do
    test "with valid data updates the user", %{user: user} do
      update_attrs = %{address: %{door_number: "11B", street: "ABC Street", city: "London", country: "United Kingdom", postal_code: "98765"}, phone_number: "+4912345678934", email_id: "updated@email.de"}

      assert {:ok, %User{} = user} = UserRepo.update_user(user.id, update_attrs)

      assert user.address.door_number == "11B"
      assert user.address.street == "ABC Street"
      assert user.address.city == "London"
      assert user.address.country == "United Kingdom"
      assert user.address.postal_code == "98765"
      assert user.phone_number == "+4912345678934"
      assert user.email_id == "updated@email.de"

      assert UserRepo.get_user!(user.id) == user
    end

    test "ignores user_type update", %{user: user} do
      update_attrs = %{user_type: :deliverer}

      assert {:ok, %User{} = user} = UserRepo.update_user(user.id, update_attrs)
      assert user.user_type == :buyer
      assert UserRepo.get_user!(user.id) == user
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = UserRepoFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRepo.update_user(user.id, @invalid_attrs)
      assert user == UserRepo.get_user!(user.id)
    end
  end

  test "change_create_user/1 returns a user changeset" do
    user = UserRepoFixtures.user_fixture()
    assert %Ecto.Changeset{} = UserRepo.change_create_user(user)
  end

  test "change_update_user/1 returns a user changeset" do
    user = UserRepoFixtures.user_fixture()
    assert %Ecto.Changeset{} = UserRepo.change_update_user(user)
  end
end
