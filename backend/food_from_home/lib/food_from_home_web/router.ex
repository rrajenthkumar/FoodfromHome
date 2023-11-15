defmodule FoodFromHomeWeb.Router do
  use FoodFromHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", FoodFromHomeWeb do
    pipe_through :api

    scope "/users" do
      get "/", UserController, :index
      post "/", UserController, :create
      get "/:user_id", UserController, :show
      put "/:user_id", UserController, :update
      delete "/:user_id", UserController, :delete
      get "/:user_id/seller", SellerController, :show
    end

    scope "/sellers" do
      get "/", SellerController, :index
      get "/:seller_id", SellerController, :show
      put "/:seller_id", SellerController, :update
      post "/:seller_id/food-menus", FoodMenuController, :create
      get "/:seller_id/food-menus", FoodMenuController, :index
    end

    scope "/food-menus" do
      get "/", FoodMenuController, :index
      get "/:menu_id", FoodMenuController, :show
      put "/:menu_id", FoodMenuController, :update
      delete "/:menu_id", FoodMenuController, :delete
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
