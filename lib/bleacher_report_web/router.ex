defmodule BleacherReportWeb.Router do
  use BleacherReportWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BleacherReportWeb do
    pipe_through :api

    get "/", ReactionController, :index

    post "/react", ReactionController, :react
  end
end
