defmodule Integrations.CacheTest do
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
      nil = Cache.get(:session_id)
    end

    @id "osdjkewnfiwnd"
    test "put stores the expected value when a value is passed in" do
      assert {:ok, {:session_id, @id}} = Cache.put(:session_id, @id)
    end

    test "get returns the value in the key" do
      {:ok, _} = Cache.put(:session_id, @id)

      assert @id = Cache.get(:session_id)
    end
  end
end
