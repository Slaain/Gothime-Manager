defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api

    # Routes pour les utilisateurs
    resources "/users", UserController, except: [:new, :edit]

    # Routes pour les workingtimes avec des routes personnalisées pour les utilisateurs
    get "/workingtime/:userID", WorkingTimeController, :index
    get "/workingtime/:userID/:id", WorkingTimeController, :show
    post "/workingtime/:userID", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete

    # Routes pour les clocks
    resources "/clocks", ClocksController, except: [:new, :edit]
  end
end
