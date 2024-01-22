defmodule FoodFromHomeNotifications.Workers.EmailDelivery do
  @moduledoc """
  Oban worker module for email delivery
  """
  use Oban.Worker, queue: :mailer

  alias FoodFromHomeNotifications.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    with %Swoosh.Email{} = email <- Mailer.to_struct(email_args),
         {:ok, _metadata} <- Mailer.deliver(email) do
      :ok
    end
  end
end
