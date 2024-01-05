defmodule FoodFromHome.Users.UserRepo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User

  @doc """
  Creates an user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs = %{}) do
    %User{}
    |> change_create_user(attrs)
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
  def get_user!(user_id) when is_integer(user_id) do
    user_id
    |> query()
    |> Repo.one!()
  end

  @doc """
  Gets a single user.

  Returns 'nil' if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(user_id) when is_integer(user_id) do
    user_id
    |> query()
    |> Repo.one()
  end

  defp query(user_id) when is_integer(user_id) do
    from user in User,
      where:
        user.id == ^user_id and
          user.deleted == false,
      preload: [:seller]
  end

  @doc """
  Gets a single user from email.

  Returns 'nil' if the User does not exist.

  ## Examples

      iex> get_user_from_email("abc@test.de")
      %User{}

      iex> get_user_from_email("def@test.de")
      nil

  """
  def get_user_from_email(email) when is_binary(email) do
    query =
      from user in User,
        where:
          user.email == ^email and
            user.deleted == false

    Repo.one(query)
  end

  @doc """
  Updates an user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(user = %User{}, attrs = %{}) do
    user
    |> change_update_user(attrs)
    |> Repo.update()
  end

  @doc """
  Soft deletes an user ('deleted' field is set to 'true').

  ## Examples

      iex> soft_delete_user(user)
      {:ok, %User{}}

  """
  def soft_delete_user(user = %User{}) do
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
