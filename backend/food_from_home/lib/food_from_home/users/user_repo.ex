defmodule FoodFromHome.Users.UserRepo do
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
  def get_user!(user_id), do: Repo.get!(User, user_id)

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
  Returns a list of users after applying given filters.
  ## Examples

    iex> list_users(%{user_type = :seller})
    [%User{}, ...]

  """
  def list_users(filter_params = %{} \\ %{}) do
    filters = Enum.map(filter_params, fn
                {key, value} when is_binary(key) -> {String.to_existing_atom(key), value}
                key_value_pair -> key_value_pair
              end)
    filter_users(filters)
  end

  defp filter_users(_filters = []) do
    query = from(user in User,
            where: user.deleted == false)
    Repo.all(query)
  end

  defp filter_users(filters) when is_list(filters) do
    {include_deleted, other_filters} = Keyword.pop(filters, :include_deleted, "false")
    query =
      case include_deleted do
        "true" ->
          from(user in User,
            where: ^other_filters)
        _ ->
          from(user in User,
            where: ^other_filters,
            where: user.deleted == false)
      end
    Repo.all(query)
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
