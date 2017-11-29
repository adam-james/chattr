defmodule Chattr.Accounts do
  @moduledoc """
  The accounts context.
  """  

  import Ecto.Query, warn: false
  alias Chattr.Repo

  alias Chattr.Accounts.{User, Credential}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all User
  end

  @doc """
  Gets a single user. Preloads credential.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_with_credential!(123)
      %User{}

      iex> get_user_with_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_with_credential!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credential)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` is User does not exist.

  ## Examples

      iex> get_user_!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  """
  def get_user!(id) do
    Repo.get! User, id
  end

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
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)    
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

    iex> delete_user(user)
    {:ok, %User{}}

    iex> delete_user(user)
    {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete user
  end

  @doc """
  Returns an `Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Authenticates user with password and email.

  ## Examples

    iex> authenticate_by_email_password(good_email, _password)
    {:ok, user}

    iex> authenticate_by_email_password(bad_email, _password)
    {:error, :unauthorized}

  """
  def authenticate_by_email_password(email, _password) do
    query =
      from u in User,
        inner_join: c in assoc(u, :credential),
        where: c.email == ^email

    case Repo.one(query) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end
end
