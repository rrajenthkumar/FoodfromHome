defmodule FoodFromHomeWeb.ReviewController do
  use FoodFromHomeWeb, :controller

  import Ecto.Query, warn: false

  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Reviews
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils
  alias FoodFromHomeWeb.ErrorHandler
  alias FoodFromHomeWeb.Utils, as: FoodFromHomeWebUtils

  action_fallback FoodFromHomeWeb.FallbackController

  @allowed_update_attrs_for_buyer [:rating, :buyer_note]
  @allowed_update_attrs_for_seller [:seller_reply]

  def index(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{
        "seller_id" => seller_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        case Sellers.seller_belongs_to_user?(seller, current_user) do
          true ->
            filters =
              conn
              |> fetch_query_params()
              |> Utils.convert_map_to_keyword_list()

            reviews = Reviews.list_reviews_from_seller(seller, filters)

            render(conn, :index, reviews: reviews)
          false ->
              ErrorHandler.handle_error(
                conn,
                :forbidden,
                "Seller does not belong to the current user"
              )
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Seller not found")
    end
  end

  def index(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "seller_id" => seller_id
      }) do
    case Sellers.get_seller(seller_id) do
      %Seller{} = seller ->
        filters =
          conn
          |> fetch_query_params()
          |> Utils.convert_map_to_keyword_list()

        reviews = Reviews.list_reviews_from_seller(seller, filters)

        render(conn, :index, reviews: reviews)

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Seller not found")
    end
  end

  def create(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    with {:ok, %Order{} = order} <- run_preliminary_checks_for_create(conn, order_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, %Review{} = review} <- Reviews.create_review(order, attrs) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/v1/orders/#{order_id}/review")
        |> render(:show, review: review)
      end
    end
  end

  def show(conn = %{assigns: %{current_user: %User{}}}, %{"order_id" => order_id}) do
    with {:ok, %Review{} = review} <- run_preliminary_checks(conn, order_id) do
      render(conn, :show, review: review)
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller}}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    with {:ok, %Review{} = review} <- run_preliminary_checks(conn, order_id) do
      attrs = Utils.convert_map_string_keys_to_atoms(attrs)

      with {:ok, attrs} <-
             FoodFromHomeWebUtils.unallowed_attributes_check(
               conn,
               attrs,
               @allowed_update_attrs_for_seller
             ) do
        with {:ok, %Review{} = review} <- Reviews.update_review(review, attrs) do
          render(conn, :show, review: review)
        end
      end
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    with {:ok, %Review{} = review} <- run_preliminary_checks(conn, order_id) do
      with {:ok, %Review{} = review} <-
             run_additional_checks(conn, review) do
        attrs = Utils.convert_map_string_keys_to_atoms(attrs)

        with {:ok, attrs} <-
               FoodFromHomeWebUtils.unallowed_attributes_check(
                 conn,
                 attrs,
                 @allowed_update_attrs_for_buyer
               ) do
          with {:ok, %Review{} = review} <- Reviews.update_review(review, attrs) do
            render(conn, :show, review: review)
          end
        end
      end
    end
  end

  def delete(conn = %{assigns: %{current_user: %User{user_type: :buyer}}}, %{
        "order_id" => order_id
      }) do
    with {:ok, %Review{} = review} <- run_preliminary_checks(conn, order_id) do
      with {:ok, %Review{} = review} <-
             run_additional_checks(conn, review) do
        with {:ok, %Review{}} <- Reviews.delete_review(review) do
          send_resp(conn, :no_content, "")
        end
      end
    end
  end

  defp run_preliminary_checks_for_create(
         conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}},
         order_id
       )
       when is_integer(order_id) do
    order_result = Orders.get(order_id)

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      order_result.status != :delivered ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Order is in #{order_result.status} status. Review can be added only for a delivered order."
        )

      true ->
        {:ok, order_result}
    end
  end

  defp run_preliminary_checks(
         conn = %{assigns: %{current_user: %User{} = current_user}},
         order_id
       ) do
    order_result = Orders.get(order_id)

    review_result =
      case order_result do
        %Order{} -> Reviews.get_review_from_order(order_result)
        nil -> nil
      end

    cond do
      is_nil(order_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")

      Orders.is_order_related_to_user?(order_result, current_user) === false ->
        ErrorHandler.handle_error(conn, :forbidden, "Order not related to the current user")

      is_nil(review_result) ->
        ErrorHandler.handle_error(conn, :not_found, "Review not found")

      true ->
        {:ok, review_result}
    end
  end

  defp run_additional_checks(
         conn = %{assigns: %{current_user: %User{user_type: :buyer}}},
         review = %Review{}
       ) do
    cond do
      is_nil(review.seller_reply) === false ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Review cannot be edited or deleted as the seller has already replied"
        )

      Reviews.is_review_older_than_a_day?(review) ->
        ErrorHandler.handle_error(
          conn,
          :forbidden,
          "Review cannot be edited or deleted as it is already more than a day old"
        )

      true ->
        {:ok, review}
    end
  end
end
