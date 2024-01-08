defmodule FoodFromHome.Mailer do
  use Swoosh.Mailer, otp_app: :food_from_home

  alias FoodFromHome.Workers.EmailDelivery

  def add_email_to_oban_queue(
        _email_attributes = %{
          to: to,
          from: from,
          subject: subject,
          template: template,
          template_assigns: template_assigns
        }
      ) do
    new()
    |> to(to)
    |> from(from)
    |> subject(subject)
    |> render_body(template, template_assigns)
    |> enqueue()
  end

  defp enqueue(email) do
    with email_map <- to_map(email),
         result =
           %{email: email_map}
           |> EmailDelivery.new()
           |> Oban.insert()

    {:ok, _job} <-
      result do
        {:ok, email}
      end
  end

  def to_map(%Swoosh.Email{to: to, from: from, subject: subject, html_body: html_body} = email) do
    %{
      "to" => tuple_to_map(to),
      "from" => tuple_to_map(from),
      "subject" => subject,
      "html_body" => html_body
    }
  end

  def from_map(%{
        "to" => to,
        "from" => from,
        "subject" => subject,
        "html_body" => html_body
      }) do
    opts = [
      to: map_to_tuple(to),
      from: map_to_tuple(from),
      subject: subject,
      html_body: html_body
    ]

    Swoosh.Email.new(opts)
  end

  defp tuple_to_map({name, email}) do
    %{"name" => name, "email" => email}
  end

  defp map_to_tuple(%{"name" => name, "email" => email}) do
    {name, email}
  end
end
