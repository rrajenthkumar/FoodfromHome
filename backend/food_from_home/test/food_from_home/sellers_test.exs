defmodule FoodFromHome.SellersTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Sellers

  describe "sellers" do
    alias FoodFromHome.Sellers.Seller

    import FoodFromHome.SellersFixtures

    @invalid_attrs %{illustration: nil, introduction: nil, tax_id: nil}

    test "list_sellers/0 returns all sellers" do
      seller = seller_fixture()
      assert Sellers.list_sellers() == [seller]
    end

    test "get_seller!/1 returns the seller with given id" do
      seller = seller_fixture()
      assert Sellers.get_seller!(seller.id) == seller
    end

    test "create_seller/1 with valid data creates a seller" do
      valid_attrs = %{illustration: "some illustration", introduction: "some introduction", tax_id: "some tax_id"}

      assert {:ok, %Seller{} = seller} = Sellers.create_seller(valid_attrs)
      assert seller.illustration == "some illustration"
      assert seller.introduction == "some introduction"
      assert seller.tax_id == "some tax_id"
    end

    test "create_seller/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sellers.create_seller(@invalid_attrs)
    end

    test "update_seller/2 with valid data updates the seller" do
      seller = seller_fixture()
      update_attrs = %{illustration: "some updated illustration", introduction: "some updated introduction", tax_id: "some updated tax_id"}

      assert {:ok, %Seller{} = seller} = Sellers.update_seller(seller, update_attrs)
      assert seller.illustration == "some updated illustration"
      assert seller.introduction == "some updated introduction"
      assert seller.tax_id == "some updated tax_id"
    end

    test "update_seller/2 with invalid data returns error changeset" do
      seller = seller_fixture()
      assert {:error, %Ecto.Changeset{}} = Sellers.update_seller(seller, @invalid_attrs)
      assert seller == Sellers.get_seller!(seller.id)
    end

    test "delete_seller/1 deletes the seller" do
      seller = seller_fixture()
      assert {:ok, %Seller{}} = Sellers.delete_seller(seller)
      assert_raise Ecto.NoResultsError, fn -> Sellers.get_seller!(seller.id) end
    end

    test "change_seller/1 returns a seller changeset" do
      seller = seller_fixture()
      assert %Ecto.Changeset{} = Sellers.change_seller(seller)
    end
  end
end
