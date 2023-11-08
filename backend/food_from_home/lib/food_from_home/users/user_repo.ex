defmodule FoodFromHome.Users.UserRepo do
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> change_user(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(user_id), do: Repo.get!(User, user_id)

  @doc """
  Gets a single active (not deleted) user using email id.
  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_active_user_from_email_id!("x@y.com")
      %User{}

      iex> get_active_user_from_email_id!("y@z.com")
      ** (Ecto.NoResultsError)

  """
  def get_active_user_from_email_id!(email_id), do: Repo.one!(from user in User, where: user.email_id == ^email_id and user.deleted == false)

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(234, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(457, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(user_id, attrs) do
    user_id
    |> get_user!()
    |> change_user(attrs)
    |> Repo.update()
  end

  @doc """
  Marks an User as 'deleted'.
  Whenever an user is to be deleted it is just marked as deleted rather than removing it completely from the table, to preserve the history.

  ## Examples

      iex> mark_user_as_deleted(234)
      {:ok, %User{}}

      iex> mark_user_as_deleted(567)
      {:error, %Ecto.Changeset{}}

  """
  def mark_user_as_deleted(user_id) do
    update_user(user_id, %{deleted: true})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

end
