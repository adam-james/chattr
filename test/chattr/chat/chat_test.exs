defmodule Chattr.ChatTest do
  use Chattr.DataCase
  
  alias Chattr.Chat

  describe "topics" do
    alias Chattr.Chat.Topic

    @valid_attrs %{title: "some title", description: "some description"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      topics = Chat.list_topics()
      assert topics == [topic]
    end

    test "get_topic!/1 returns the topic with the given id" do
      topic = topic_fixture()
      assert Chat.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates topic" do
      assert {:ok, topic} = Chat.create_topic @valid_attrs
      assert topic.title == "some title"
      assert topic.description == "some description"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_topic @invalid_attrs
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
