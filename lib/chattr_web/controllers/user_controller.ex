defmodule ChattrWeb.UserController do
  use ChattrWeb, :controller
  
  alias Chattr.Accounts
  alias Chattr.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render conn, "index.html", users: users
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user_with_credential! id
    render conn, "show.html", user: user
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user_with_credential! id
    changeset = Accounts.change_user(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_with_credential! id

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user! id
    {:ok, _user} = Accounts.delete_user user

    conn
    |> put_flash(:info, "User deleted.")
    |> redirect(to: user_path(conn, :index))
  end
end
