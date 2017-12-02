defmodule Chattr.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias Chattr.Repo

  alias Chattr.Chat.{Topic, Message}
  alias Chattr.Accounts.User

  @doc """
  Returns a list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Topic
    |> Repo.all()
    |> Repo.preload(:user)
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

  @doc """
  Returns a list of messages for a given topic id. Preloads users.

  ## Examples

      iex> list_messages(123)
      [%Message{}, ...]

  """
  def list_messages(topic_id) when is_integer(topic_id) do
    query = from m in Message, where: m.topic_id == ^topic_id, order_by: m.id
    query
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%User{}, %Topic{}, %{field: value})
      {:ok, %Message{}}

      iex> create_message(%User{}, %Topic{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(%User{} = user, %Topic{} = topic, attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Ecto.Changeset.put_change(:topic_id, topic.id)
    |> Repo.insert()
  end
end
