defmodule FoodFromHome.Notifications.SendOrderConfirmationEmailToBuyer do
  alias FoodFromHome.Notifications.Utils
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_web/templates/emails",
    template_path: "order"

  def call(order = %Order{id: order_id, status: :confirmed}) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = Utils.full_name(buyer_user)

    %User{email: seller_email, seller: %Seller{nickname: seller_nickname}} =
      Users.get_seller_user_from_order!(order)

    new()
    |> to({buyer_full_name, buyer_email})
    |> from({"FoodfromHome", "foodfromhome@xyz.com"})
    |> subject("Order #{order_id} confirmed")
    |> render_body("order_confirmation_to_buyer.html", %{
      order_id: order_id,
      buyer_full_name: buyer_full_name,
      seller_nickname: seller_nickname,
      seller_email: seller_email
    })
  end
end
