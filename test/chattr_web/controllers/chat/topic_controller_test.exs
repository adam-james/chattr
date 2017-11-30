defmodule ChattrWeb.Chat.TopicControllerTest do
  use ChattrWeb.ConnCase
  
  alias Chattr.Accounts
  alias Chattr.Chat

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "updated description", title: "updated title"}
  @invalid_attrs %{description: nil, title: nil}
  @user_attrs %{username: "some username", credential: %{email: "someemail@test.com"}}
  @other_user_attrs %{username: "some other username", credential: %{email: "other@test.com"}}

  def fixture(:user_topic, user) do
    {:ok, topic} = Chat.create_topic user, @create_attrs
    topic
  end

  def fixture(:topic) do
    user = fixture(:user)
    topic = fixture :user_topic, user
    topic
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  def fixture(:other_user) do
    {:ok, other_user} = Accounts.create_user(@other_user_attrs)
    other_user
  end

  describe "no user" do
    test "index redirects when no user", %{conn: conn} do
      conn = get conn, chat_topic_path(conn, :index)
      assert_rejected conn
      assert Chat.list_topics() == []      
    end

    test "new redirects when no user", %{conn: conn} do
      conn = get conn, chat_topic_path(conn, :new)
      assert_rejected conn
      assert Chat.list_topics() == []      
    end

    test "show redirects when no user", %{conn: conn} do
      topic = fixture(:topic)
      conn = get conn, chat_topic_path(conn, :show, topic)
      assert_rejected conn
    end

    test "create redirects when no user", %{conn: conn} do
      conn = post conn, chat_topic_path(conn, :create), topic: @create_attrs
      assert_rejected conn
      assert Chat.list_topics() == []      
    end

    test "edit redirects when no user", %{conn: conn} do
      topic = fixture(:topic)
      conn = get conn, chat_topic_path(conn, :edit, topic)
      assert_rejected conn
    end

    test "update redirects when no user", %{conn: conn} do
      topic = fixture(:topic)
      conn = get conn, chat_topic_path(conn, :update, topic), topic: @update_attrs
      assert_rejected conn, topic
    end

    test "delete redirects when no user", %{conn: conn} do
      topic = fixture(:topic)
      conn = delete conn, chat_topic_path(conn, :delete, topic)
      assert_rejected conn, topic
    end

    defp assert_rejected(conn) do
      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Login required"
    end

    defp assert_rejected(conn, topic) do
      assert_rejected conn
      db_topic = Chat.get_topic! topic.id
      assert db_topic.updated_at == db_topic.updated_at
    end
  end

  describe "owner user" do
    setup %{conn: conn} do
      user = fixture(:user)
      conn = Plug.Test.init_test_session(conn, user_id: user.id)
      {:ok, %{conn: conn, user: user}}
    end

    test "lists all topics when user", %{conn: conn} do
      conn = get conn, chat_topic_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Topics"
    end

    test "new renders form when user", %{conn: conn} do
      conn = get conn, chat_topic_path(conn, :new)
      assert html_response(conn, 200) =~ "New Topic"
    end

    test "create creates topic when data is valid", %{conn: conn, user: user} do
      conn = post conn, chat_topic_path(conn, :create), topic: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == chat_topic_path(conn, :show, id)

      conn = get conn, chat_topic_path(conn, :show, id)     
      assert html_response(conn, 200) =~ "Created by: #{user.username}"
    end

    test "create renders errors when data is invalid", %{conn: conn} do
      conn = post conn, chat_topic_path(conn, :create), topic: @invalid_attrs
      assert html_response(conn, 200) =~ "New Topic"
    end

    test "edit renders form for editing topic for user", %{conn: conn, user: user} do
      topic = fixture :user_topic, user
      conn = get conn, chat_topic_path(conn, :edit, topic)
      assert html_response(conn, 200) =~ "Edit Topic"
    end

    test "update updates topics when data valid", %{conn: conn, user: user} do
      topic = fixture :user_topic, user
      conn  = put conn, chat_topic_path(conn, :update, topic), topic: @update_attrs
      assert redirected_to(conn) == chat_topic_path(conn, :show, topic)

      conn = get conn, chat_topic_path(conn, :show, topic)
      assert html_response(conn, 200) =~ "updated description"
    end

    test "update renders errors when data is invalid", %{conn: conn, user: user} do
      topic = fixture :user_topic, user      
      conn  = put conn, chat_topic_path(conn, :update, topic), topic: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Topic"
    end

    test "deletes topic for owner user", %{conn: conn, user: user} do
      topic = fixture :user_topic, user
      conn  = delete conn, chat_topic_path(conn, :delete, topic)
      assert redirected_to(conn) == chat_topic_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, chat_topic_path(conn, :show, topic)
      end
    end
  end

  describe "non-owner user" do
    setup %{conn: conn} do
      user = fixture(:user)
      other_user = fixture(:other_user)
      conn = Plug.Test.init_test_session(conn, user_id: user.id)
      other_user_topic = fixture :user_topic, other_user
      {:ok, %{conn: conn, user: user, other_user: other_user, 
              other_user_topic: other_user_topic}}
    end

    test "edit rejects non-owner user", %{conn: conn, other_user_topic: other_user_topic} do
      conn = get conn, chat_topic_path(conn, :edit, other_user_topic)
      assert_cant_modify conn
    end

    test "update rejects non-owner user", %{conn: conn, other_user_topic: other_user_topic} do
      conn = put conn, chat_topic_path(conn, :update, other_user_topic), topic: @update_attrs
      assert_cant_modify conn
    end

    test "delete rejects non-owner user", %{conn: conn, other_user_topic: other_user_topic} do
      conn = delete conn, chat_topic_path(conn, :delete, other_user_topic)
      assert_cant_modify conn
    end

    defp assert_cant_modify(conn) do
      assert redirected_to(conn) == chat_topic_path(conn, :index)
      assert get_flash(conn, :error) == "You can't modify that topic."   
    end
  end
end
