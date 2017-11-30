defmodule ChattrWeb.Chat.TopicView do
  use ChattrWeb, :view

  def owner_name(topic) do
    topic.user.username
  end
end
