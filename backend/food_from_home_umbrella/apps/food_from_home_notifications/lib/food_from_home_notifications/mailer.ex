defmodule FoodFromHomeNotifications.Mailer do
  use Swoosh.Mailer, otp_app: :food_from_home_notifications

  use Phoenix.Swoosh,
    template_root: "lib/food_from_home_notifications_web/templates",
    template_path: "emails"

  alias FoodFromHomeNotifications.Workers.EmailDelivery

  def add_email_to_oban_queue(
        _email_parameters = %{
          to: to,
          subject: subject,
          template: template,
          template_assigns: template_assigns
        }
      ) do
    new()
    |> to(to)
    |> from({"FoodfromHome", "foodfromhome@xyz.com"})
    |> subject(subject)
    |> render_body(template, template_assigns)
    |> enqueue()
  end

  def to_struct(%{
        "to" => to,
        "from" => from,
        "subject" => subject,
        "html_body" => html_body
      }) do
    opts = [
      to: to_tuple(to),
      from: to_tuple(from),
      subject: subject,
      html_body: html_body
    ]

    Swoosh.Email.new(opts)
  end

  defp enqueue(email_struct = %Swoosh.Email{}) do
    result =
      %{email: to_map(email_struct)}
      |> EmailDelivery.new()
      |> Oban.insert()

    with {:ok, _job} <- result do
      {:ok, email_struct}
    end
  end

  defp to_map(%Swoosh.Email{to: to, from: from, subject: subject, html_body: html_body}) do
    %{
      "to" => to_map(to),
      "from" => to_map(from),
      "subject" => subject,
      "html_body" => html_body
    }
  end

  defp to_map({name, email}) do
    %{"name" => name, "email" => email}
  end

  defp to_tuple(%{"name" => name, "email" => email}) do
    {name, email}
  end
end
