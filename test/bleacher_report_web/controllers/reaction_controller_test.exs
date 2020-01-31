defmodule BleacherReportWeb.ReactionControllerTest do
  use BleacherReportWeb.ConnCase

  describe "Reactions Controller" do

    test "index/2 return a text message", %{conn: conn} do
      conn =
        conn
        |> get(reaction_path(conn, :index))

      assert text_response(conn, 200) =~ "Welcome to the bleacher report"
    end
  end
end
