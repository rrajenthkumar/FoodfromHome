defmodule FoodFromHome.Users.UserRepo do
  import Ecto.Query, warn: false

  alias FoodFromHome.Repo
  alias FoodFromHome.Users.User
  alias FoodFromHome.Utils

  @doc """
  Creates an user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
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
    |> get_query()
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
    |> get_query()
    |> Repo.one()
  end

  defp get_query(user_id) do
    from user in User,
      join: seller in assoc(user, :seller),
      where: user.id == ^user_id,
      preload: [:seller]
  end

  @doc """
  Updates an user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
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

      iex> soft_delete_user(user)
      {:ok, %User{}}

  """
  def soft_delete(user = %User{}) do
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
  def list(filter_params = %{} \\ %{}) do
    filter_params
    |> Utils.convert_map_to_keyword_list()
    |> list_query()
    |> Repo.all()
  end

  defp list_query(_filters = []) do
    from user in User,
      join: seller in assoc(user, :seller),
      where: user.deleted == false,
      preload: [:seller]
  end

  defp list_query(filters) when is_list(filters) do
    {include_deleted, other_filters} = Keyword.pop(filters, :include_deleted, "false")

    case include_deleted do
      "true" ->
        from user in User,
          join: seller in assoc(user, :seller),
          where: ^other_filters,
          preload: [:seller]

      _ ->
        from user in User,
          join: seller in assoc(user, :seller),
          where: ^other_filters,
          where: user.deleted == false,
          preload: [:seller]
    end
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
