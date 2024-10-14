defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug TimeManagerApiWeb.Plugs.CORS  # Utilise le plug CORS ici
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api

    # Routes pour les workingtimes
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    get "/workingtimes/:userID", WorkingTimeController, :index

    # Routes pour les workingtimes avec des routes personnalisées pour les utilisateurs
    get "/workingtime/:userID", WorkingTimeController, :index
    get "/workingtime/:userID/:id", WorkingTimeController, :show
    post "/workingtime/:userID", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete

    # Routes pour tester
    post "/test/:id", TestController, :update_working_time

    get "/users", UserController, :paginated_users
    resources "/users", UserController, except: [:new, :edit]

    # Routes pour les clocks
    post "/clocks/:user_id", ClockController, :beep

    # Route pour les requêtes OPTIONS
    match :options, "/*_path", TimeManagerApiWeb.CORSController, :options
  end
end
