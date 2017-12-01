defmodule ChattrWeb.Chat.TopicController do
  use ChattrWeb, :controller

  alias Chattr.Chat
  alias Chattr.Chat.Topic

  plug :authorize_topic when action in [:edit, :update, :delete]

  def index(conn, _params) do
    user = conn.assigns.current_user
    topics = Chat.list_topics()
    user_topics = for topic <- topics, user_topic?(user, topic), do: topic
    other_topics = for topic <- topics, !user_topic?(user, topic), do: topic
    render conn, "index.html", user_topics: user_topics, other_topics: other_topics
  end

  defp user_topic?(user, topic) do
    user.id == topic.user_id
  end

  def new(conn, _params) do
    changeset = Chat.change_topic(%Topic{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    case Chat.create_topic(conn.assigns.current_user, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created.")
        |> redirect(to: chat_topic_path(conn, :show, topic))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Chat.get_topic! id
    render conn, "show.html", topic: topic
  end

  def edit(conn, _) do
    changeset = Chat.change_topic(conn.assigns.topic)
    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"topic" => topic_params}) do
    case Chat.update_topic(conn.assigns.topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated.")
        |> redirect(to: chat_topic_path(conn, :show, topic))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end

  def delete(conn, _) do
    {:ok, _topic} = Chat.delete_topic conn.assigns.topic
    
    conn
    |> put_flash(:info, "Topic deleted.")
    |> redirect(to: chat_topic_path(conn, :index))
  end

  defp authorize_topic(conn, _) do
    topic = Chat.get_topic!(conn.params["id"])

    if conn.assigns.current_user.id == topic.user_id do
      assign(conn, :topic, topic)
    else
      conn
      |> put_flash(:error, "You can't modify that topic.")
      |> redirect(to: chat_topic_path(conn, :index))
      |> halt()
    end
  end
end
