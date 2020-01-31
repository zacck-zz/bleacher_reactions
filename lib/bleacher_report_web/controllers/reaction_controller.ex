defmodule BleacherReportWeb.ReactionController do
  use BleacherReportWeb, :controller
  alias BleacherReport.Cache

  @welcome_message """
  Welcome to the bleacher report reactions api
  The following actions are available;
  1. React by sending a POST request with a JSON payload to /react
  2. Count content reactions by sending GET request to /reaction_counts/:content_id
  """

  @doc """
  Index controller to handle visits to the root path on the API
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, @welcome_message)
  end

  @doc """
  Reaction controller to handle addition and removal of reactions on the API
  """
  @spec react(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def react(conn, %{"content_id" =>  key, "user_id" => uid, "action" => "add"} = value) do
    with {:ok, {^key, [_ | _]}} <- Cache.put(key, value) do
      conn
      |> put_resp_content_type("text/json")
      |> put_status(201)
      |> json(%{"content_id" => uid})
    else
      err ->
        conn
        |> put_resp_content_type("text/json")
        |> send_resp(400, err)
    end
  end

end

