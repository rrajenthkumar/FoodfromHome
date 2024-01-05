defmodule FoodFromHomeWeb.Router do
  use FoodFromHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", FoodFromHomeWeb do
    scope "/auth" do
      get "/:provider", AuthController, :request
      get "/:provider/logout", AuthController, :logout
    end

    scope "/" do
      pipe_through [:api]

      scope "/auth" do
        get "/:provider/callback", AuthController, :callback
      end

      scope "/users" do
        # Creates a new user (along with a new seller in case of :seller user type)
        post "/", UserController, :create
      end

      scope "/" do
        pipe_through [FoodFromHomeWeb.AuthenticationPipeline]

        scope "/users" do
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

            # Lists sellers with limited fields (along with average rating and user info) based on query parameters (to search based on location, text etc) for current buyer user
            get "/", SellerController, :index

            # Gets a seller (along with average rating, user info and available food menus) for current buyer user
            get "/:seller_id", SellerController, :show
          end

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsSellerPlug]

            # Creates a food menu linked to current seller user
            post "/:seller_id/food-menus", FoodMenuController, :create

            # Lists only own food menus based on query parameters with limited fields for current seller user
            get "/:seller_id/food-menus", FoodMenuController, :index
            # Updates a food menu linked to current seller user. No linked order must exist.
            put "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :update
            # Deletes a food menu linked to current seller user. No linked order must exist.
            delete "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :delete
          end

          scope "/" do
            pipe_through [FoodFromHomeWeb.IsSellerOrBuyerPlug]

            # Gets food menu with food_menu_id for current buyer user
            # Gets only own food menu with food_menu_id for current seller user
            get "/:seller_id/food-menus/:food_menu_id", FoodMenuController, :show

            # Lists reviews of a seller based on query parameters with limited fields for current seller or buyer user
            get "/:seller_id/reviews", ReviewController, :index
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

            # Gets a cart item with food menu preload from an order linked to current buyer, seller or deliverer user
            get "/:order_id/cart_items/:cart_item_id", CartItemController, :index

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
              # Delivery date should not be more than a month old.
              post "/:order_id/review", ReviewController, :create

              # To delete a review for an order linked to current buyer user.
              # Review should not have a reply or be older than a day.
              delete "/:order_id/review", ReviewController, :delete
            end

            scope "/" do
              pipe_through [FoodFromHomeWeb.IsSellerOrBuyerPlug]

              # To update the review for an order linked to current buyer or seller user.
              # A buyer can update the fields 'Stars' and 'Note'. Delivery should not be more than a month old.
              # A seller can update the field 'Reply' after the buyer has added his 'Note' and / or 'Stars'.
              # Once reply has been added or 1 day has passed since adding the review it cannot be updated by buyer further.
              # Once 1 day has passed since adding the reply it cannot be updated by seller further.
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
              get "/:order_id/delivery", DeliveryController, :show
            end
          end
        end
      end
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
