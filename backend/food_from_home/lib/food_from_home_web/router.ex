defmodule FoodFromHomeWeb.Router do
  use FoodFromHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", FoodFromHomeWeb do
    pipe_through [:api]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api/v1", FoodFromHomeWeb do
    pipe_through [:api]

    scope "/" do
      scope "/users" do
        # To create a new user and also a seller in case of seller user type.
        post "/", UserController, :create
        # To list sellers with limited fields based on query parameters for filtering.
        get "/", UserController, :index
        # To get an user same as current user.
        get "/:user_id", UserController, :show
        # To update an user same as current user.
        put "/:user_id", UserController, :update
        # To soft delete an user same as current user.
        delete "/:user_id", UserController, :delete
      end

      scope "/sellers" do
        # To create a food menu linked to current user of type seller.
        post "/:seller_id/food-menus", FoodMenuController, :create
        # To list food menus with limited fields for a seller.
        get "/:seller_id/food-menus", FoodMenuController, :index
        # To get a food menu.
        get "/:seller_id/food-menus/menu_id", FoodMenuController, :show
        # To update a food menu linked to current seller user. No linked order must exist.
        put "/:seller_id/food-menus/menu_id", FoodMenuController, :update
        # To delete a food menu linked to current seller user. No linked order must exist.
        delete "/:seller_id/food-menus/menu_id", FoodMenuController, :delete
      end

      scope "/orders" do
        # To create a order when the current user is of type buyer.
        post "/", OrderController, :create
        # Lists orders with limited fields based on query parameters for filtering. Only deliveries of orders related to current buyer or seller user are listed.
        # Orders must be linked to current seller, buyer or deliverer user. For 'ready for pickup' orders they must be from within the deliverer's city.
        get "/", OrderController, :index
        # To get order linked to current buyer, seller or deliverer user. Add search option to list cart items too.
        get "/:order_id", OrderController, :show
        # To update order linked to current buyer, seller or deliverer user.
        # Buyer can update delivery address.
        # Once payment is closed status is set to 'confimed' and invoice is is added.
        # If status is 'confirmed' seller can change status to 'ready for pick up' or 'cancelled' and add remark.
        # If status is 'ready for pickup' deliverer can change status to 'reserved for pickup'.
        # If status is 'reserved for pickup' deliverer can change status to 'on the way'.
        # If status is 'on the way' deliverer can change status to 'delivered'.
        put "/:order_id", OrderController, :update
        # To delete an unconfirmed order linked to current buyer user.
        delete "/:order_id", OrderController, :delete

        # To create a cart item for an order linked to current buyer user.
        post "/:order_id/cart_items", CartItemController, :create
        # To list a cart items for an order linked to current buyer, seller or deliverer user.
        get "/:order_id/cart_items", CartItemController, :index
        # To update a cart item for an order linked to current buyer user. Order must be of 'open' status.
        put "/:order_id/cart_items/:cart_item_id", CartItemController, :update
        # To delete a cart item for an order linked to current buyer user. Order must be of 'open' status.
        delete "/:order_id/cart_items/:cart_item_id", CartItemController, :delete

        # To create a delivery for an order linked to current deliverer user and is in 'on the way' status.
        post "/:order_id/delivery", DeliveryController, :create
        # To get a delivery for an order linked to current seller or buyer or deliverer user.
        get "/:order_id/delivery", DeliveryController, :show
        # To update a delivery for an order linked to current deliverer user.
        # Current location and distance travelled must be ideally updated automatically by deliverer's device location tracker. We mock this behaviour.
        # When delivery is confirmed by deliverer 'delivered at' is added and order status is changed to 'delivered'.
        put "/:order_id/delivery", DeliveryController, :update

        # To create a review for an order linked to current buyer user and is in 'delivered' status.
        post "/:order_id/review", ReviewController, :create
        # To get a review of an order linked to current buyer or seller user.
        get "/:order_id/review", ReviewController, :show
        # To update a review for an order linked to current buyer or seller user.
        # A buyer can update the fields 'Stars' and 'Note'. A seller can update the field 'Reply'.
        # Once reply has been added the review cannot be updated further.
        put "/:order_id/review", ReviewController, :update
        # To delete a review for an order linked to current buyer user. Delivery should have been not earlier than in the past one month.
        # Once reply has been added the review cannot be deleted.
        delete "/:order_id/review", ReviewController, :delete
      end

      scope "/deliveries" do
        # Lists deliveries with limited fields based on query parameters for filtering. Only deliveries of orders related to current buyer or seller user are listed.
        get "/", DeliveryController, :index
      end

      scope "/reviews" do
        # Lists reviews with limited fields based on query parameters for filtering. Only reviews of orders related to current buyer or seller user are listed.
        get "/", ReviewController, :index
      end

      # TO DO: pagination & sorting feature are to be added for all index function routes
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:food_from_home, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FoodFromHomeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
