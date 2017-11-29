defmodule ChattrWeb.Chat.TopicController do
  use ChattrWeb, :controller
  
  alias Chattr.Chat

  plug :authorize_topic when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Chat.list_topics()
    render conn, "index.html", topics: topics
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
