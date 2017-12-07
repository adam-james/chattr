defmodule Chattr.ChatTest do
  use Chattr.DataCase
  
  alias Chattr.Chat
  alias Chattr.Accounts
  alias Chattr.Repo

  describe "topics" do
    alias Chattr.Chat.Topic

    @valid_attrs %{title: "some title", description: "some description"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}
    @user_attrs %{username: "some username", credential: %{email: "someemail@test.com"}}

    def topic_fixture(attrs \\ %{}) do
      attrs = Enum.into attrs, @valid_attrs
      user = user_fixture()
      {:ok, topic} = Chat.create_topic user, attrs
      topic
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture() |> Repo.preload(:user)
      topics = Chat.list_topics()
      assert topics == [topic]
    end

    test "get_topic!/1 returns the topic with the given id and user preloaded" do
      topic = topic_fixture() |> Repo.preload(:user)
      assert Chat.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data and user creates topic" do
      user = user_fixture()
      assert {:ok, topic} = Chat.create_topic user, @valid_attrs
      assert topic.title == "some title"
      assert topic.description == "some description"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.create_topic user, @invalid_attrs
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Chat.update_topic topic, @update_attrs
      assert %Topic{} = topic
      assert topic.title == "some updated title"
    end

    test "update_topic/2 with invalid data returns an error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_topic topic, @invalid_attrs
      assert topic = Chat.get_topic! topic.id
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Chat.delete_topic topic
      assert_raise Ecto.NoResultsError, fn -> Chat.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Chat.change_topic topic
    end
  end
end
