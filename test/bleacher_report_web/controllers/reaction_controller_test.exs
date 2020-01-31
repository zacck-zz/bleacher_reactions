defmodule BleacherReportWeb.ReactionControllerTest do
  use BleacherReportWeb.ConnCase
  alias BleacherReport.Cache

  describe "Reactions Controller" do

    test "index/2 return a text message", %{conn: conn} do
      conn =
        conn
        |> get(reaction_path(conn, :index))

      assert text_response(conn, 200) =~ "Welcome to the bleacher report"
    end

    test "react/2 should add a reaction to a content's list of reactions", %{conn: conn} do
      content_id = "some_react_content"

      reaction = %{
        "type" => "reaction",
        "action" => "add",
        "content_id" => content_id,
        "user_id" => "some_user_id",
        "reaction_type" => "fire"
      }

      assert {:error, nil} = Cache.get(content_id)

      conn =
        conn
        |> post(reaction_path(conn, :react, reaction))

      assert json_response(conn, 201) == %{"content_id" => content_id, "user_id" => reaction["user_id"]}
    end

    test "count/2 should fetch reaction counts for a content_id", %{conn: conn} do
      content_id = "some_count_content"

      reaction = %{
        "type" => "reaction",
        "action" => "add",
        "content_id" => content_id,
        "user_id" => "some_user_id",
        "reaction_type" => "fire"
      }

      reaction1 = %{
        "type" => "reaction",
        "action" => "remove",
        "content_id" => content_id,
        "user_id" => "some_user_id",
        "reaction_type" => "fire"
      }

      reaction2 = %{
        "type" => "reaction",
        "action" => "add",
        "content_id" => content_id,
        "user_id" => "some_remaining_id",
        "reaction_type" => "fire"
      }

      conn =
        conn
        |> post(reaction_path(conn, :react, reaction))
        |> post(reaction_path(conn, :react, reaction2))
        |> post(reaction_path(conn, :react, reaction1))
        |> get(reaction_path(conn, :count, content_id))


      assert json_response(conn, 200)
    end
  end
end
