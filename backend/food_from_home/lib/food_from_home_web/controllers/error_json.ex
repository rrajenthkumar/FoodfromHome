defmodule FoodFromHomeWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns = %{detail: error_detail}) do
    %{errors: %{status: Phoenix.Controller.status_message_from_template(template), detail: error_detail}}
  end

  def render(template, _assigns) do
    %{errors: %{status: Phoenix.Controller.status_message_from_template(template)}}
  end
end
