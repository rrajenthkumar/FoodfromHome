defmodule FoodFromHome.Notification do
  @moduledoc """
  Module to manage notifications
  """
  alias FoodFromHome.Mailer
  alias FoodFromHome.Orders
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users
  alias FoodFromHome.Users.User

  def trigger(order_id, type) when is_integer(order_id) and is_atom(type) do
    order_id
    |> Orders.get_order!()
    |> get_email_parameters(type)
    |> Mailer.add_email_to_oban_queue()
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :confirmed},
         _type = :order_confirmation_to_buyer
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    %User{email: seller_email, seller: %Seller{nickname: seller_nickname}} =
      Users.get_seller_user_from_order!(order)

    %{
      to: {buyer_full_name, buyer_email},
      subject: "Order #{order_id} confirmed",
      template: "order_confirmation_to_buyer.html",
      template_assigns: %{
        order_id: order_id,
        buyer_full_name: buyer_full_name,
        seller_nickname: seller_nickname,
        seller_email: seller_email
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :confirmed},
         _type = :order_confirmation_to_seller
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    seller_user = %User{email: seller_email} = Users.get_seller_user_from_order!(order)
    seller_full_name = full_name(seller_user)

    %{
      to: {seller_full_name, seller_email},
      subject: "Order #{order_id} confirmed",
      template: "order_confirmation_to_seller.html",
      template_assigns: %{
        order_id: order_id,
        seller_full_name: seller_full_name,
        buyer_full_name: buyer_full_name,
        buyer_email: buyer_email
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, seller_remark: seller_remark, status: :cancelled},
         _type = :order_cancellation_notification_to_buyer
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    %User{email: seller_email, seller: %Seller{nickname: seller_nickname}} =
      Users.get_seller_user_from_order!(order)

    %{
      to: {buyer_full_name, buyer_email},
      subject: "Order #{order_id} cancelled",
      template: "order_cancellation_notification.html",
      template_assigns: %{
        order_id: order_id,
        buyer_full_name: buyer_full_name,
        seller_nickname: seller_nickname,
        seller_email: seller_email,
        seller_remark: seller_remark
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :open},
         _type = :payment_assistance_info_to_buyer
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    %{
      to: {buyer_full_name, buyer_email},
      subject: "Payment assistance for Order #{order_id}",
      template: "payment_assistance_info.html",
      template_assigns: %{
        order_id: order_id,
        buyer_full_name: buyer_full_name
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :on_the_way},
         _type = :delivery_tracking_info_to_buyer
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    deliverer_user =
      %User{phone_number: deliverer_phone_number} = Users.get_deliverer_user_from_order!(order)

    deliverer_full_name = full_name(deliverer_user)

    %{
      to: {buyer_full_name, buyer_email},
      subject: "Delivery tracking for order #{order_id}",
      template: "delivery_tracking_info.html",
      template_assigns: %{
        order_id: order_id,
        buyer_full_name: buyer_full_name,
        deliverer_full_name: deliverer_full_name,
        deliverer_phone_number: deliverer_phone_number
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :delivered},
         _type = :review_request_to_buyer
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    %{
      to: {buyer_full_name, buyer_email},
      subject: "Request to review order #{order_id}",
      template: "review_request.html",
      template_assigns: %{
        order_id: order_id,
        buyer_full_name: buyer_full_name
      }
    }
  end

  defp get_email_parameters(
         order = %Order{id: order_id, status: :delivered},
         _type = :review_addition_notification_to_seller
       ) do
    buyer_user = %User{email: buyer_email} = Users.get_buyer_user_from_order!(order)
    buyer_full_name = full_name(buyer_user)

    seller_user = %User{email: seller_email} = Users.get_seller_user_from_order!(order)
    seller_full_name = full_name(seller_user)

    %{
      to: {seller_full_name, seller_email},
      subject: "Review added for order #{order_id}",
      template: "review_addition_notification.html",
      template_assigns: %{
        order_id: order_id,
        seller_full_name: seller_full_name,
        buyer_full_name: buyer_full_name,
        buyer_email: buyer_email
      }
    }
  end

  defp full_name(%User{salutation: salutation, first_name: first_name, last_name: last_name}) do
    salutation = Atom.to_string(salutation)

    "#{salutation}. #{first_name} #{last_name}"
  end
end
