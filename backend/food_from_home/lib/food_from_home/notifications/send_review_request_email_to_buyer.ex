defmodule FoodFromHome.Notifications.SendReviewRequestEmailToBuyer do
  alias FoodFromHome.Notifications.Utils
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_web/templates/emails",
    template_path: "review"

  def call(order = %Order{id: order_id, status: :delivered}) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = Utils.full_name(buyer_user)

    new()
    |> to({buyer_full_name, buyer_email})
    |> from({"FoodfromHome", "foodfromhome@xyz.com"})
    |> subject("Request to review order #{order_id}")
    |> render_body("review_request.html", %{
      order_id: order_id,
      buyer_full_name: buyer_full_name
    })
  end
end
