defmodule FoodFromHome.Notifications.SendDeliveryTrackingEmailToBuyer do
  alias FoodFromHome.Notifications.Utils
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_web/templates/emails",
    template_path: "delivery"

  def call(order = %Order{id: order_id, status: :on_the_way}) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = Utils.full_name(buyer_user)

    deliverer_user =
      %User{phone_number: deliverer_phone_number} = Users.get_deliverer_user_from_order!(order)

    deliverer_full_name = Utils.full_name(deliverer_user)

    new()
    |> to({buyer_full_name, buyer_email})
    |> from({"FoodfromHome", "foodfromhome@xyz.com"})
    |> subject("Delivery tracking for order #{order_id}")
    |> render_body("delivery_tracking.html", %{
      order_id: order_id,
      buyer_full_name: buyer_full_name,
      deliverer_full_name: deliverer_full_name,
      deliverer_phone_number: deliverer_phone_number
    })
  end
end
