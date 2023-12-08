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
    pipe_through [:api, FoodFromHomeWeb.AuthenticationPlug]

    scope "/" do
      scope "/users" do
        # Creates a new user (along with a new seller in case of :seller user type)
        post "/", UserController, :create
        # Gets current user (along with seller details in case of :seller user type) with user_id
        get "/:user_id", UserController, :show
        # Updates current user (along with seller details in case of :seller user type)
        put "/:user_id", UserController, :update
        # Soft deletes current user
        delete "/:user_id", UserController, :delete
      end

      scope "/sellers" do
        scope "/" do
          pipe_through [FoodFromHomeWeb.IsBuyerPlug]

          # Lists sellers with limited fields (along with user info) based on query parameters (to search based on location, text etc) for current buyer user
          get "/", SellerController, :index
          # Gets a seller (along with user info and food menu) for current buyer user
          get "/:seller_id", SellerController, :show
          # Lists reviews of a seller based on query parameters with limited fields for current buyer user
          get "/:seller_id/reviews", ReviewController, :index
        end

        scope "/" do
          pipe_through [FoodFromHomeWeb.IsSellerPlug]

          # Updates a seller
          put "/:seller_id", SellerController, :update
          # Creates a food menu linked to current seller user
          post "/:seller_id/food-menus", FoodMenuController, :create
          # Updates a food menu linked to current seller user. No linked order must exist.
          put "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :update
          # Deletes a food menu linked to current seller user. No linked order must exist.
          delete "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :delete
        end

        scope "/" do
          pipe_through [FoodFromHomeWeb.IsSellerOrBuyerPlug]

          # Lists food menus of a seller based on query parameters with limited fields for current buyer user
          # Lists only own food menus based on query parameters with limited fields for current seller user
          get "/:seller_id/food-menus", FoodMenuController, :index
          # Gets food menu with food_menu_id for current buyer user
          # Gets only own food menu with food_menu_id for current seller user
          get "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :show
        end
      end

      scope "/orders" do
        scope "/" do

          # Lists all orders related to current buyer or seller user, with limited fields, based on query parameters
          # For a deliverer user, lists orders within the deliverer's city with 'ready for pickup' status,
          get "/", OrderController, :index
          # Gets an order linked to current buyer, seller or deliverer user with order_id
          # Add option to expand buyer, seller, deliverer, delivery, cart items, foodmenu details
          get "/:order_id", OrderController, :show
          # Updates order linked to current buyer, seller or deliverer user
          # Status update can be done based on the type of user and current status
          put "/:order_id", OrderController, :update
          # Lists cart items from an order linked to current buyer, seller or deliverer user
          get "/:order_id/cart_items", CartItemController, :index
          # To get the review of an order linked to current buyer, seller or deliverer user.
          get "/:order_id/review", ReviewController, :show

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsBuyerPlug]

            # Creates an order linked to current buyer user along with a cart item
            # Route to be used when the first cart item is added
            post "/", OrderController, :create
            # Deletes an order linked to current buyer user along with cart items
            # Route to be used when the cart is emptied
            delete "/:order_id", OrderController, :delete
            # Creates a cart item for an existing order linked to current buyer user. Order must be of 'open' status.
            post "/:order_id/cart_items", CartItemController, :create
            # Updates a cart item for an order linked to current buyer user. Order must be of 'open' status.
            put "/:order_id/cart_items/:cart_item_id", CartItemController, :update
            # Deletes a cart item for an order linked to current buyer user. Order must be of 'open' status.
            delete "/:order_id/cart_items/:cart_item_id", CartItemController, :delete
            # To create a review for an order linked to current buyer user. Order must be in 'delivered' status.
            post "/:order_id/review", ReviewController, :create
            # To delete a review for an order linked to current buyer user. Delivery should not be more than a month old.
            # Once reply has been added the review cannot be deleted.
            delete "/:order_id/review", ReviewController, :delete
          end

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsSellerOrBuyerPlug]
            # To update the review for an order linked to current buyer or seller user.
            # A buyer can update the fields 'Stars' and 'Note'. Delivery should not be more than a month old.
            # A seller can update the field 'Reply' after the buyer has added his 'Note' and / or 'Stars'.
            # Once reply has been added the review cannot be updated further.
            put "/:order_id/review", ReviewController, :update
          end

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsDelivererPlug]

            # For updates by deliverer's device location tracker. Currently we mock it.
            put "/:order_id/delivery", DeliveryController, :update
          end

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsSellerOrDelivererPlug]

            # Lists deliveries linked to current seller or deliverer user with limited fields based on query parameters
            get "/deliveries", DeliveryController, :index
            # To get a delivery for an order linked to current seller or deliverer user
            # Add option to expand order, buyer, seller, delivery, cart items, foodmenu details
            get "/:order_id/delivery", DeliveryController, :show
          end
        end
      end
      # TO DO: pagination & sorting feature for all :index function routes
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
