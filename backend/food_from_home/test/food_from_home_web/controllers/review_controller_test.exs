defmodule FoodFromHomeWeb.ReviewControllerTest do
  use FoodFromHomeWeb.ConnCase

  import FoodFromHome.ReviewsFixtures

  alias FoodFromHome.Reviews.Review

  @create_attrs %{
    note: "some note",
    stars: :"1"
  }
  @update_attrs %{
    note: "some updated note",
    stars: :"2"
  }
  @invalid_attrs %{note: nil, stars: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reviews", %{conn: conn} do
      conn = get(conn, ~p"/api/reviews")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create review" do
    test "renders review when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/reviews", review: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/reviews/#{id}")

      assert %{
               "id" => ^id,
               "note" => "some note",
               "stars" => "1"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/reviews", review: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update review" do
    setup [:create_review]

    test "renders review when data is valid", %{conn: conn, review: %Review{id: id} = review} do
      conn = put(conn, ~p"/api/reviews/#{review}", review: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/reviews/#{id}")

      assert %{
               "id" => ^id,
               "note" => "some updated note",
               "stars" => "2"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, review: review} do
      conn = put(conn, ~p"/api/reviews/#{review}", review: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete review" do
    setup [:create_review]

    test "deletes chosen review", %{conn: conn, review: review} do
      conn = delete(conn, ~p"/api/reviews/#{review}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/reviews/#{review}")
      end
    end
  end

  defp create_review(_) do
    review = review_fixture()
    %{review: review}
  end
end
