defmodule Chattr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chattr.Accounts.User

  schema "users" do
    field :username, :string

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
