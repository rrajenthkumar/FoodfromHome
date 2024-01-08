defmodule FoodFromHome.Workers.EmailDelivery do
  @moduledoc false
  use Oban.Worker, queue: :mailer

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_web/templates",
    template_path: "emails"

  alias FoodFromHome.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    with email <- Mailer.from_map(email_args),
         {:ok, _metadata} <- Mailer.deliver(email) do
      :ok
    end
  end
end
