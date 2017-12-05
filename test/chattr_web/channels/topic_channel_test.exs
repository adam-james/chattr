defmodule ChattrWeb.TopicChannelTest do
  use ChattrWeb.ChannelCase
  
  alias ChattrWeb.TopicChannel
  alias Chattr.Accounts
  alias Chattr.Chat
  alias Chattr.Repo
  alias Chattr.Chat.Message

  @user_attrs  %{username: "test", credential: %{email: "test@test.com"}}
  @msg_attrs   %{body: "test message"}
  @topic_attrs %{title: "test title", description: "test description"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user @user_attrs
    user
  end

  def fixture(:user_topic, user) do
    {:ok, topic} = Chat.create_topic user, @topic_attrs
    topic
  end

  setup do
    user = fixture :user
    topic = fixture :user_topic, user
    {:ok, _, socket} =
      socket("my_sock", %{user_id: user.id})
      |> subscribe_and_join(TopicChannel, "topic:#{Integer.to_string(topic.id)}")

    {:ok, socket: socket, user: user, topic: topic}
  end

  test "new_msg broadcasts to topic:topic_id", %{socket: socket, topic: topic, user: user} do
    push socket, "new_msg", @msg_attrs
    assert_broadcast "new_msg", %{body: "test message", id: id}
    
    message = get_message!(id)
    assert message
    assert message.topic_id == topic.id
    assert message.user_id  == user.id
  end

  defp get_message!(id) do
    Repo.get! Message, id
  end
end
