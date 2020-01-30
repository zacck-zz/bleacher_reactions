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
      1 + 1
    end)

    :ok = Application.start(:bleacher_report)
  end


  describe "Cache" do
    test "get returns nil if an item isn't saved in the cache" do
      nil = Cache.get("some_non_existent_id")
    end

    test "put stores the expected value when a value is passed in" do
      content_id = "some_content_id"
      add_user_id = "some_add_id"

      reaction = %{
        type: :reaction,
        action: :add,
        content_id: content_id,
        user_id: add_user_id,
        reaction_type: :fire
      }



      assert {:ok, {^content_id, %{user_id: ^add_user_id}}} = Cache.put(:session_id, reaction)
    end

    test "get returns the value in the key" do
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

      assert [%{user_id: ^other_add_user_id, content_id: ^content_id}] = Cache.get(content_id)
    end
  end
end
