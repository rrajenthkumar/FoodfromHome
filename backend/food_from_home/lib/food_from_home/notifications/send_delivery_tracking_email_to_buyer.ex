defmodule FoodFromHome.Notifications.SendDeliveryTrackingEmailToBuyer do
  alias FoodFromHome.Notifications.Utils
  alias FoodFromHome.Mailer
  alias FoodFromHome.Orders
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def call(order_id) when is_integer(order_id) do
    order_id
    |> prepare_email_attributes
    |> Mailer.add_email_to_oban_queue()
  end

  defp prepare_email_attributes(order_id) when is_integer(order_id) do
    order = Orders.get_order!(order_id)

    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = Utils.full_name(buyer_user)

    deliverer_user =
      %User{phone_number: deliverer_phone_number} = Users.get_deliverer_user_from_order!(order)

    deliverer_full_name = Utils.full_name(deliverer_user)

    to = {buyer_full_name, buyer_email}

    from = {"FoodfromHome", "foodfromhome@xyz.com"}

    subject = "Delivery tracking for order #{order_id}"

    template = "delivery_tracking.html"

    template_assigns = %{
      order_id: order_id,
      buyer_full_name: buyer_full_name,
      deliverer_full_name: deliverer_full_name,
      deliverer_phone_number: deliverer_phone_number
    }

    %{
      to: to,
      from: from,
      subject: subject,
      template: template,
      template_assigns: template_assigns
    }
  end
end
