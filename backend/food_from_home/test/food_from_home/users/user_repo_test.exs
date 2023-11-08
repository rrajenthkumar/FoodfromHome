defmodule FoodFromHome.Users.UserRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Users.UserRepo

  describe "users" do
    alias FoodFromHome.Users.User

    import FoodFromHome.UsersFixtures

    @invalid_attrs %{address: nil, phone_number: nil, email_id: nil, first_name: nil, gender: nil, last_name: nil, user_type: nil}

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{address: %{}, phone_number: "+4912345678912", email_id: "some email_id", first_name: "some first_name", gender: :male, last_name: "some last_name", user_type: :buyer}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.address == %{}
      assert user.phone_number == "+4912345678912"
      assert user.email_id == "some email_id"
      assert user.first_name == "some first_name"
      assert user.gender == :male
      assert user.last_name == "some last_name"
      assert user.profile_image == nil
      assert user.user_type == :buyer
      assert user.deleted == false
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{address: %{}, phone_number: "+4912345678934", email_id: "some updated email_id", first_name: "some updated first_name", gender: :female, last_name: "some updated last_name", profile_image: "some updated profile_image", user_type: :seller, deleted: true}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.address == %{}
      assert user.phone_number == "+4912345678934"
      assert user.email_id == "some updated email_id"
      assert user.first_name == "some updated first_name"
      assert user.gender == :female
      assert user.last_name == "some updated last_name"
      assert user.profile_image == "some updated profile_image"
      assert user.user_type == :seller
      assert user.deleted == true
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
