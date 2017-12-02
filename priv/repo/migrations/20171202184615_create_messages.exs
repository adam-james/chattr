defmodule Chattr.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false
      add :topic_id, references(:topics, on_delete: :delete_all),
                     null: false

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:topic_id])
  end
end
