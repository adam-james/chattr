defmodule Chattr.Chat.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chattr.Chat.Topic
  alias Chattr.Accounts.User
  
  schema "topics" do
    field :description, :string
    field :title, :string
    belongs_to :user, User
    
    timestamps()
  end

  @doc false
  def changeset(%Topic{} = topic, attrs) do
    topic
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
