defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/clocks/:user_id", ClockController, only: [:create, :index]
  end


end
