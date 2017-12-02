defmodule ChattrWeb.TopicChannel do
  use Phoenix.Channel

  alias Chattr.Accounts
  
  def join("topic:" <> topic_id, _params, socket) do
    topic_id = String.to_integer topic_id
    resp = %{topic_id: topic_id}
    {:ok, resp, socket}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user! socket.assigns.user_id
    handle_in(event, params, user, socket)
  end

  def handle_in("new_msg", %{"body" => body}, user, socket) do
    resp = %{body: body, user: user.username}
    broadcast! socket, "new_msg", resp
    {:noreply, socket}
  end
end
