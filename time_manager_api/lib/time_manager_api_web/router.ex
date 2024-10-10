defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug TimeManagerApiWeb.Plugs.CORS  # Utilise le plug CORS ici
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api

    # Route pour obtenir la liste des employés paginée
    get "/employees", UserController, :paginated_employees

    # Route pour obtenir les employés par utilisateur spécifique, si nécessaire
    get "/employees/:userID", UserController, :paginated_employees

    # Routes pour les workingtimes
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    get "/workingtimes/:userID", WorkingTimeController, :index

    # Routes pour les workingtimes avec des routes personnalisées pour les utilisateurs
    get "/workingtime/:userID", WorkingTimeController, :index
    get "/workingtime/:userID/:id", WorkingTimeController, :show
    post "/workingtime/:userID", WorkingTimeController, :create
    put "/workingtime/:id", WorkingTimeController, :update
    delete "/workingtime/:id", WorkingTimeController, :delete

    resources "/users", UserController, except: [:new, :edit]
    resources "/clocks/:user_id", ClockController, only: [:create, :index]

    # Route pour les requêtes OPTIONS
    match :options, "/*_path", TimeManagerApiWeb.CORSController, :options
  end
end
