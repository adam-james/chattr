defmodule Chattr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chattr.Accounts.{User, Credential}
  alias Chattr.Chat.{Topic, Message}

  schema "users" do
    field :username, :string
    has_one :credential, Credential
    has_many :topics, Topic
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
