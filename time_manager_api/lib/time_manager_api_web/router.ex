defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug TimeManagerApiWeb.Plugs.CORS  # Utilise le plug CORS ici
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api

    # Scope pour les workingtimes
    scope "/workingtimes" do
      get "/count", WorkingTimeController, :count
      get "/", WorkingTimeController, :index
      get "/:userID", WorkingTimeController, :indexA
      get "/:userID/:id", WorkingTimeController, :show
    end

    # Scope pour les workingtimes avec des routes personnalisées pour les utilisateurs
    scope "/workingtime" do
      get "/:userID", WorkingTimeController, :index
      get "/:userID/:id", WorkingTimeController, :show
      post "/:userID", WorkingTimeController, :create
      put "/:id", WorkingTimeController, :update
      delete "/:id", WorkingTimeController, :delete
    end

    # Scope pour les tests
    scope "/test" do
      post "/:id", TestController, :update_working_time
    end

    # Scope pour les utilisateurs
    scope "/users" do
      get "/", UserController, :paginated_users
      resources "/", UserController, except: [:new, :edit]
    end

    # Scope pour les clocks
    scope "/clocks" do
      post "/:user_id", ClockController, :beep
      get "/countactive", ClockController, :countactive
    end

    # Route pour les requêtes OPTIONS (utilisées pour le CORS)
    match :options, "/*_path", TimeManagerApiWeb.CORSController, :options
  end
end
