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

  action_fallback FoodFromHomeWeb.FallbackController

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

  def create(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    case Orders.get(order_id) do
      %Order{status: order_status} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case order_status do
              :delivered ->
                attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                with {:ok, %Review{} = review} <- Reviews.create(order, attrs) do
                  conn
                  |> put_status(:created)
                  |> put_resp_header("location", ~p"/api/v1/orders/#{order_id}/review")
                  |> render(:show, review: review)
                end

              another_status ->
                ErrorHandler.handle_error(
                  conn,
                  :forbidden,
                  "Order is in #{another_status} status. Review can be added only for a delivered order."
                )
            end

          false ->
            ErrorHandler.handle_error(conn, :forbidden, "Order not related to the user")
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def show(conn = %{assigns: %{current_user: %User{} = current_user}}, %{"order_id" => order_id}) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case Reviews.find_review_from_order(order) do
              %Review{} = review ->
                render(conn, :show, review: review)

              nil ->
                ErrorHandler.handle_error(conn, :not_found, "Review not found")
            end

          false ->
            ErrorHandler.handle_error(conn, :forbidden, "Order not related to the user")
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case Reviews.find_review_from_order(order) do
              %Review{seller_reply: seller_reply, inserted_at: inserted_at} = review ->
                case is_nil(seller_reply) and review_not_older_than_3_months?(inserted_at) do
                  true ->
                    attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                    with {:ok, %Review{} = review} <- Reviews.update(review, attrs) do
                      render(conn, :show, review: review)
                    end

                  false ->
                    ErrorHandler.handle_error(
                      conn,
                      :forbidden,
                      "Review cannot be edited as the seller has already replied or the review is older than 3 months"
                    )
                end

              nil ->
                ErrorHandler.handle_error(conn, :not_found, "Review not found")
            end

          false ->
            ErrorHandler.handle_error(conn, :forbidden, "Order not related to the user")
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def update(conn = %{assigns: %{current_user: %User{user_type: :seller} = current_user}}, %{
        "order_id" => order_id,
        "review" => attrs
      }) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case Reviews.find_review_from_order(order) do
              %Review{} = review ->
                attrs = Utils.convert_map_string_keys_to_atoms(attrs)

                with {:ok, %Review{} = review} <- Reviews.update(review, attrs) do
                  render(conn, :show, review: review)
                end

              nil ->
                ErrorHandler.handle_error(conn, :not_found, "Review not found")
            end

          false ->
            ErrorHandler.handle_error(conn, :forbidden, "Order not related to the user")
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  def delete(conn = %{assigns: %{current_user: %User{user_type: :buyer} = current_user}}, %{
        "order_id" => order_id
      }) do
    case Orders.get(order_id) do
      %Order{} = order ->
        case Orders.is_order_related_to_user?(order, current_user) do
          true ->
            case Reviews.find_review_from_order(order) do
              %Review{seller_reply: seller_reply, inserted_at: inserted_at} = review ->
                case is_nil(seller_reply) and review_not_older_than_3_months?(inserted_at) do
                  true ->
                    with {:ok, %Review{}} <- Reviews.delete(review) do
                      send_resp(conn, :no_content, "")
                    end

                  false ->
                    ErrorHandler.handle_error(
                      conn,
                      :forbidden,
                      "Review cannot be deleted as the the seller has already replied or the review is older than 3 months"
                    )
                end

              nil ->
                ErrorHandler.handle_error(conn, :not_found, "Review not found")
            end

          false ->
            ErrorHandler.handle_error(conn, :forbidden, "Order not related to the user")
        end

      nil ->
        ErrorHandler.handle_error(conn, :not_found, "Order not found")
    end
  end

  defp review_not_older_than_3_months?(review_inserted_at) do
    {:ok, review_creation_date_with_time} = DateTime.from_naive(review_inserted_at, "Etc/UTC")
    current_date_with_time = DateTime.utc_now()

    # To check if the difference is greater than 90 days
    DateTime.diff(review_creation_date_with_time, current_date_with_time) <= 90 * 24 * 60 * 60
  end
end
