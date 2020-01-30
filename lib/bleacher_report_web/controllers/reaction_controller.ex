defmodule BleacherReportWeb.ReactionController do
  use BleacherReportWeb, :controller

  @welcome_message """
  Welcome to the bleacher report reactions api
  The following actions are available;
  1. React by sending a POST request with a JSON payload to /react
  2. Count content reactions by sending GET request to /reaction_counts/:content_id
  """

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, @welcome_message)
  end
end

