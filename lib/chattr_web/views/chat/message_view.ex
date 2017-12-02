defmodule ChattrWeb.Chat.MessageView do
  use ChattrWeb, :view
  
  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      body: message.body,
      created_by: message.user.username
    }
  end

  def render("message.json", user, %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      body: message.body,
      created_by: user.username
    }    
  end
end
