defmodule Chattr.Chat.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chattr.Chat.Topic
  
  schema "topics" do
    field :description, :string
    field :title, :string
    
    timestamps()
  end

  @doc false
  def changeset(%Topic{} = topic, attrs) do
    topic
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
