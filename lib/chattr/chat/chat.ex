defmodule Chattr.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias Chattr.Repo

  alias Chattr.Chat.Topic
  alias Chattr.Accounts.User

  @doc """
  Returns a list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Repo.all Topic
  end

  @doc """
  Gets a single topic. Preloads the user.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%User{}, %{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(%User{} = user, attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete topic
  end

  @doc """
  Returns an `%Ecto.Changeset{} for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  def change_topic(%Topic{} = topic) do
    Topic.changeset topic, %{}
  end
end
