defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router

  pipeline :api do
    plug TimeManagerApiWeb.Plugs.CORS  # Utilise le plug CORS ici
    plug :accepts, ["json"]
    plug TimeManagerApiWeb.Plugs.AssignCurrentUser  # Assigne l'utilisateur si un token est présent

  end

  pipeline :checkManager do
    plug TimeManagerApiWeb.Plugs.CheckManagerRole
  end

  pipeline :checkManagerOrAdminRole do
    plug TimeManagerApiWeb.Plugs.CheckManagerOrAdminRole
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api


    scope "/qrcode" do
      post "/beep", QRCodeController, :beep
      get "/:organizationId", QRCodeController, :get_token

      pipe_through :checkManagerOrAdminRole
      post "/generate/:organizationId", QRCodeController, :generate_qr
      post "/test", QRCodeController, :test
    end

    # Scope pour les workingtimes
    scope "/workingtimes" do
      get "/daily/:userID", WorkingTimeController, :get_workingtimes_daily
  get "/weekly/:userID", WorkingTimeController, :get_workingtimes_weekly
  get "/monthly/:userID", WorkingTimeController, :get_workingtimes_monthly
      get "/count", WorkingTimeController, :count
      get "/", WorkingTimeController, :index
      get "/by_organisation/:organisation_id", WorkingTimeController, :by_organisation
      get "/count_by_organisation/:organisation_id", WorkingTimeController, :count_by_organisation

      get "/:userID", WorkingTimeController, :indexA
      get "/:userID/:id", WorkingTimeController, :show

    end

    # Scope pour les workingtimes avec des routes personnalisées pour les utilisateurs
    scope "/workingtime" do
      get "/today/:userID", WorkingTimeController, :get_working_times_today
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
      post "/", UserController, :create
      resources "/", UserController, except: [:new, :edit]
    end

    # Scope pour les clocks
    scope "/clocks" do
      post "/:organization_id/:user_id", ClockController, :beep
      get "/countactive", ClockController, :countactive
      get "/countactive_by_organisation/:organisation_id", ClockController, :countactive_by_organisation

    end


    # Route pour les requêtes OPTIONS (utilisées pour le CORS)
    match :options, "/*_path", TimeManagerApiWeb.CORSController, :options


  # Group routes
  get "/groups", GroupController, :index      # Liste des groupes
  post "/groups", GroupController, :create    # Créer un groupe
  get "/groups/:id", GroupController, :show   # Afficher un groupe spécifique
  delete "/groups/:id", GroupController, :delete
  put "/groups/:id", GroupController, :update
  get "/groups/user/:user_id", GroupController, :get_group_by_user



      # Routes pour gérer les utilisateurs dans les groupes
    post "/groups/:group_id/users/:user_id", GroupController, :add_user    # Ajouter un utilisateur à un groupe
    delete "/groups/:group_id/users/:user_id", GroupController, :remove_user # Retirer un utilisateur d'un groupe

  # routes pour les organisations
  scope "/organisations" do
    get "/", OrganisationController, :index
    post "/", OrganisationController, :create
    get "/:id/users", OrganisationController, :users
    get "/:id", OrganisationController, :show
    delete "/:id", OrganisationController, :delete
    put "/:id", OrganisationController, :update
    put "/:organisation_id/users/:user_id/:role_id", OrganisationController, :update_user_role
    delete "/:organisation_id/users/:user_id", OrganisationController, :remove_user



  end

  scope "/roles" do
    get "/", RoleController, :show
  end

  #Routes pour l'authentification
  post "/register", AuthController, :register  # Route pour l'inscription
  post "/login", AuthController, :login        # Route pour la connexion
  post "/decrypt_token", AuthController, :decrypt_token  # Route pour décrypter le token



  end
end
