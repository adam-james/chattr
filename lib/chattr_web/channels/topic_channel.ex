defmodule ChattrWeb.TopicChannel do
  use Phoenix.Channel

  alias Chattr.Accounts
  alias Chattr.Chat
  alias ChattrWeb.Chat.MessageView
  
  def join("topic:" <> topic_id, _params, socket) do
    topic_id = String.to_integer topic_id

    messages = Chat.list_messages(topic_id)
    messages = Phoenix.View.render_many(messages, MessageView, "message.json")
    resp = %{messages: messages}

    {:ok, resp, assign(socket, :topic_id, topic_id)}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user! socket.assigns.user_id
    handle_in(event, params, user, socket)
  end

  def handle_in(event, params, user, socket) do
    topic = Chat.get_topic! socket.assigns.topic_id
    handle_in(event, params, user, topic, socket)
  end

  def handle_in("new_msg", %{"body" => body}, user, topic, socket) do
    case Chat.create_message(user, topic, %{body: body}) do
      {:ok, message} ->
        resp = MessageView.render("message.json", user, %{message: message})
        broadcast! socket, "new_msg", resp
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, :error, socket}
    end
  end
end
