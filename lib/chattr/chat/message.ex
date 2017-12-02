defmodule Chattr.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chattr.Chat.{Message, Topic}
  alias Chattr.Accounts.User


  schema "messages" do
    field :body, :string
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
