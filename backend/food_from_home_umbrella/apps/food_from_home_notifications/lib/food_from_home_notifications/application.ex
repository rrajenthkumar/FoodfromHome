defmodule FoodFromHomeNotifications.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FoodFromHomeNotificationsWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:food_from_home_notifications, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FoodFromHomeNotifications.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FoodFromHomeNotifications.Finch},
      # Start a worker by calling: FoodFromHomeNotifications.Worker.start_link(arg)
      # {FoodFromHomeNotifications.Worker, arg},
      # Start to serve requests, typically the last entry
      FoodFromHomeNotificationsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodFromHomeNotifications.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodFromHomeNotificationsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
