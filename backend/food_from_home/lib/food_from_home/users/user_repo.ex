defmodule FoodFromHome.Users.UserRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Creates an user.

  ## Examples

      iex> create(%{field: value})
      {:ok, %User{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs = %{}) do
    %User{}
    |> change_create_user(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get!(123)
      %User{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(user_id) do
    user_id
    |> query()
    |> Repo.one!()
  end

  @doc """
  Gets a single user.

  Returns 'nil' if the User does not exist.

  ## Examples

      iex> get(123)
      %User{}

      iex> get(456)
      nil

  """
  def get(user_id) do
    user_id
    |> query()
    |> Repo.one()
  end

  defp query(user_id) do
    from user in User,
      join: seller in assoc(user, :seller),
      where:
        user.id == ^user_id and
          user.deleted == false,
      preload: [seller: seller]
  end

  @doc """
  Updates an user.

  ## Examples

      iex> update(user, %{field: new_value})
      {:ok, %User{}}

      iex> update(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(user = %User{}, attrs = %{}) do
    user
    |> change_update_user(attrs)
    |> Repo.update()
  end

  @doc """
  Soft deletes an user ('deleted' field is set to 'true').

  ## Examples

      iex> soft_delete(user)
      {:ok, %User{}}

  """
  def soft_delete(user = %User{}) do
    user
    |> User.soft_delete_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes during user creation.

  ## Examples

      iex> change_create_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_create_user(user = %User{}, attrs = %{} \\ %{}) do
    User.create_changeset(user, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes during user updation.

  ## Examples

      iex> change_update_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_update_user(user = %User{}, attrs = %{} \\ %{}) do
    User.update_changeset(user, attrs)
  end
end
