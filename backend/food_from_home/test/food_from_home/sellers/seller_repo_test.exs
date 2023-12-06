defmodule FoodFromHome.Sellers.SellerRepoTest do
  use FoodFromHome.DataCase

  alias FoodFromHome.Sellers.SellerRepo
  alias FoodFromHome.FoodMenus
  alias FoodFromHome.Sellers.SellerRepoFixtures

  describe "sellers" do
    alias FoodFromHome.Sellers.Seller

    import FoodFromHome.FoodMenus.SellerRepoFixtures

    @invalid_attrs %{illustration: nil, introduction: nil, tax_id: nil}

    test "get_seller!/1 returns the seller with given id" do
      seller = seller_fixture()
      assert SellerRepo.get_seller!(seller.id) == seller
    end

    test "create_seller/1 with valid data creates a seller" do
      valid_attrs = %{illustration: "some illustration", introduction: "some introduction", tax_id: "some tax_id"}

      assert {:ok, %Seller{} = seller} = SellerRepo.create_seller(valid_attrs)
      assert seller.illustration == "some illustration"
      assert seller.introduction == "some introduction"
      assert seller.tax_id == "some tax_id"
    end

    test "create_seller/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SellerRepo.create_seller(@invalid_attrs)
    end

    test "update_seller/2 with valid data updates the seller" do
      seller = seller_fixture()
      update_attrs = %{illustration: "some updated illustration", introduction: "some updated introduction", tax_id: "some updated tax_id"}

      assert {:ok, %Seller{} = seller} = SellerRepo.update_seller(seller, update_attrs)
      assert seller.illustration == "some updated illustration"
      assert seller.introduction == "some updated introduction"
      assert seller.tax_id == "some updated tax_id"
    end

    test "update_seller/2 with invalid data returns error changeset" do
      seller = seller_fixture()
      assert {:error, %Ecto.Changeset{}} = SellerRepo.update_seller(seller, @invalid_attrs)
      assert seller == SellerRepo.get_seller!(seller.id)
    end

    test "change_seller/1 returns a seller changeset" do
      seller = seller_fixture()
      assert %Ecto.Changeset{} = SellerRepo.change_seller(seller)
    end
  end
end
