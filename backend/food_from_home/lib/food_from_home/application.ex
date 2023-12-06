defmodule FoodFromHome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FoodFromHomeWeb.Telemetry,
      # Start the Ecto repository
      FoodFromHome.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FoodFromHome.PubSub},
      # Start Finch
      {Finch, name: FoodFromHome.Finch},
      # Start the Endpoint (http/https)
      FoodFromHomeWeb.Endpoint,
      #Kaffe's Consumer module
      # {Kaffe.Consumer, []}
      # Start a worker by calling: FoodFromHome.Worker.start_link(arg)
      # {FoodFromHome.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodFromHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodFromHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
