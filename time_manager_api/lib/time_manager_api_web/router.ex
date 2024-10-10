defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api


    # Routes pour les workingtimes
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    get "/workingtimes/:userID", WorkingTimeController, :index



    # Routes pour les workingtimes avec des routes personnalisées pour les utilisateurs
   # get "/workingtime/:userID", WorkingTimeController, :index
    #get "/workingtime/:userID/:id", WorkingTimeController, :show
    #post "/workingtime/:userID", WorkingTimeController, :create
    #put "/workingtime/:id", WorkingTimeController, :update
    #delete "/workingtime/:id", WorkingTimeController, :delete

    resources "/users", UserController, except: [:new, :edit]
    resources "/clocks/:user_id", ClockController, only: [:create, :index]
  end
end
