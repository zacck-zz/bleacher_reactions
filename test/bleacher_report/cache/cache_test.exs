defmodule BreacherReport.CacheTest do
  @moduledoc """
  This modules holds unit tests for the functionalities provided by the Cache Module in Kachuma
  """
  use ExUnit.Case, async: false

  @moduletag :capture_log
  alias BleacherReport.Cache

  setup do
    Application.stop(:bleacher_report)
    Process.sleep(4)

    on_exit(fn ->
    end)

    :ok = Application.start(:bleacher_report)
  end


  describe "Cache" do
    test "get returns nil if an item isn't saved in the cache" do
      {:error, nil} = Cache.get("some_non_existent_id")
    end

    test ".put/2 stores the expected value when a value is passed in" do
      content_id = "some_content_id"
      add_user_id = "some_add_id"

      reaction = %{
        type: :reaction,
        action: :add,
        content_id: content_id,
        user_id: add_user_id,
        reaction_type: :fire
      }



      assert {:ok, {^content_id, [%{user_id: ^add_user_id}]}} = Cache.put(content_id, reaction)
    end

    test ".get/1 returns the value in the key" do
      content_id = "some_get_content_id"
      other_add_user_id = "some_other_add_user_id"

      reaction = %{
        type: :reaction,
        action: :add,
        content_id: content_id,
        user_id: other_add_user_id,
        reaction_type: :fire
      }

      {:ok, _} = Cache.put(content_id, reaction)

      assert {:ok, [%{user_id: ^other_add_user_id, content_id: ^content_id}]} = Cache.get(content_id)
    end


    test ".remove/1 removed a reaction if it exists" do
      content_id = "some_remove_content_id"
      remove_user_id  = "some_remove_user_id"

      retained_user_id = "some_remained_user_id"

      reaction = %{
        type: :reaction,
        action: :add,
        content_id: content_id,
        user_id: remove_user_id,
        reaction_type: :fire
      }

      reaction1 = %{
        type: :reaction,
        action: :add,
        content_id: content_id,
        user_id: retained_user_id,
        reaction_type: :fire
      }

      {:ok, _} = Cache.put(content_id, reaction)
      {:ok, _} = Cache.put(content_id, reaction1)



      {:ok, items} = Cache.get(content_id)

      # we put two reactions in
       assert Enum.count(items) == 2

      {:ok, {^content_id, left_reactions}} = Cache.remove(reaction)

      {:ok, lefts} = Cache.get(content_id)

      assert Enum.count(lefts) == Enum.count(left_reactions)

      assert Enum.count(lefts) == 1
    end
  end
end
