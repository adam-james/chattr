defmodule ChattrWeb.SessionControllerTest do
  use ChattrWeb.ConnCase
  
  alias Chattr.Accounts

  @create_attrs %{username: "some user", credential: %{email: "someemail@test.com"}}
  @valid_login %{email: "someemail@test.com", password: "password"}
  @invalid_login %{email: "royalnonesuch@test.com", password: "oops"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Log In"
    end
  end

  describe "create session" do
    setup [:create_user]

    test "redirects when login data is valid", %{conn: conn, user: user} do
      conn = post conn, session_path(conn, :create), user: @valid_login
      assert redirected_to(conn) == page_path(conn, :index)
      assert get_session(conn, :user_id) == user.id
    end

    test "renders errors when login data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: @invalid_login
      assert redirected_to(conn) == session_path(conn, :new)
      assert get_flash(conn, :error) == "Bad email/password combination"
      refute get_session(conn, :user_id)
    end
  end

  describe "delete session" do
    test "deletes session", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 123)
        |> delete(session_path(conn, :delete))

      assert redirected_to(conn) == page_path(conn, :index)
      # TODO: figure out why this doesn't work
      refute get_session(conn, :user_id)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
