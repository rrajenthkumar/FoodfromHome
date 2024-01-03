defmodule FoodFromHomeWeb.OrderJSON do
  alias FoodFromHome.CartItems.CartItem
  alias FoodFromHome.Deliveries.Delivery
  alias FoodFromHome.FoodMenus.FoodMenu
  alias FoodFromHome.FoodMenus.FoodMenu.Rebate
  alias FoodFromHome.Orders.Order
  alias FoodFromHome.Orders.Order.DeliveryAddress
  alias FoodFromHome.Reviews.Review
  alias FoodFromHome.Sellers.Seller
  alias FoodFromHome.Users.User

  @doc """
  Renders a list of orders with limited data
  """
  def index(%{orders: orders}) do
    %{data: for(order <- orders, do: limited_data(order))}
  end

  @doc """
  Renders a single order
  """
  def show(%{order: order}) do
    %{data: data(order)}
  end

  defp limited_data(order = %Order{}) do
    %{
      id: order.id,
      created_at: order.inserted_at,
      status: order.status
    }
  end

  defp data(
         order = %Order{
           seller: {%Seller{} = seller, seller_user: %User{} = seller_user},
           buyer_user: %User{} = buyer_user,
           cart_items: cart_items,
           delivery: {%Delivery{} = delivery, deliverer_user: %User{} = deliverer_user},
           review: %Review{} = review
         }
       )
       when is_list(cart_items) do
    %{
      id: order.id,
      created_at: order.inserted_at,
      updated_at: order.updated_at,
      status: order.status,
      seller: data(seller),
      seller_user: data(seller_user),
      buyer_user: data(buyer_user),
      cart_items: for(cart_item <- cart_items, do: data(cart_item)),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark,
      delivery_address: data(order.delivery_address),
      delivery: data(delivery),
      deliverer_user: data(deliverer_user),
      review: data(review)
    }
  end

  defp data(order = %Order{}) do
    %{
      id: order.id,
      created_at: order.inserted_at,
      updated_at: order.updated_at,
      status: order.status,
      seller_id: order.seller_id,
      buyer_user_id: order.buyer_user_id,
      delivery_address: data(order.delivery_address),
      invoice_link: order.invoice_link,
      seller_remark: order.seller_remark
    }
  end

  defp data(seller = %Seller{}) do
    %{
      id: seller.id,
      nickname: seller.nickname
    }
  end

  defp data(user = %User{}) do
    %{
      id: user.id,
      email_id: user.email_id
    }
  end

  defp data({%CartItem{} = cart_item, food_menu: %FoodMenu{} = food_menu}) do
    %{
      cart_item: %{
        id: cart_item.id,
        count: cart_item.count,
        remark: cart_item.remark,
        food_menu: data(food_menu)
      }
    }
  end

  defp data(food_menu = %FoodMenu{}) do
    %{
      id: food_menu.id,
      name: food_menu.name,
      price: food_menu.price,
      rebate: data(food_menu.rebate)
    }
  end

  defp data(rebate = %Rebate{}) do
    %{
      count: rebate.count,
      discount_percentage: rebate.discount_percentage
    }
  end

  defp data(delivery_address = %DeliveryAddress{}) do
    %{
      door_number: delivery_address.door_number,
      street: delivery_address.street,
      city: delivery_address.city,
      country: delivery_address.country,
      postal_code: delivery_address.postal_code
    }
  end

  defp data(delivery = %Delivery{}) do
    %{
      id: delivery.id,
      picked_up_at: delivery.picked_up_at,
      delivered_at: delivery.delivered_at
    }
  end

  defp data(review = %Review{}) do
    %{
      id: review.id,
      rating: review.rating,
      buyer_note: review.buyer_note,
      seller_reply: review.seller_reply
    }
  end
end
