defmodule FoodFromHome.Auth.Identity do
  @moduledoc """
  This struct represents the Identitiy accessible on each connection
  """
  @enforce_keys [:user_id]
  defstruct user_id: nil

  @type t() :: [
          user_id: String.t()
        ]
end
