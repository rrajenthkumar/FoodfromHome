defmodule FoodFromHome.Notifications.Utils do
  def full_name(%User{salutation: salutation, first_name: first_name, last_name: last_name}) do
    salutation = Atom.to_string(salutation)

    "#{salutation}. #{first_name} #{last_name}"
  end
end
