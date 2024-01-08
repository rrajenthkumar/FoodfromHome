defmodule FoodFromHome.Notifications.SendOrderCancellationEmailToBuyer do
  alias FoodFromHome.Notifications.Utils
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_web/templates/emails",
    template_path: "order"

  def call(order_id) when is_integer(order_id) do
    order = %Order{seller_remark: seller_remark} = Orders.get_order!(order_id)

    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = Utils.full_name(buyer_user)

    %User{email: seller_email, seller: %Seller{nickname: seller_nickname}} =
      Users.get_seller_user_from_order!(order)

    new()
    |> to({buyer_full_name, buyer_email})
    |> from({"FoodfromHome", "foodfromhome@xyz.com"})
    |> subject("Order #{order_id} cancelled")
    |> render_body("order_cancellation.html", %{
      order_id: order_id,
      buyer_full_name: buyer_full_name,
      seller_nickname: seller_nickname,
      seller_email: seller_email,
      seller_remark: seller_remark
    })
  end
end