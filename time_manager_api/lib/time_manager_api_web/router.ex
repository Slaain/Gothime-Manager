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
    end

    scope "/workingtime" do
      pipe_through [:checkManagerOrAdminRole]
      post "/:userID", WorkingTimeController, :create
      put "/:id", WorkingTimeController, :update
      delete "/:id", WorkingTimeController, :delete

    end

    # Scope pour les tests
    scope "/test" do
      post "/:id", TestController, :update_working_time
    end

    scope "/users" do
      # GET /api/users - liste des utilisateurs paginée
      get "/", UserController, :paginated_users

      # GET /api/users/:id - affichage d'un utilisateur spécifique
      get "/:id", UserController, :show
    end

    scope "/users" do
      pipe_through :checkManagerOrAdminRole
      # PUT /api/users/:id - mise à jour d'un utilisateur
      put "/:id", UserController, :update

      # DELETE /api/users/:id - suppression d'un utilisateur
      delete "/:id", UserController, :delete
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
  get "/groups/:id", GroupController, :show   # Afficher un groupe spécifique
  get "/groups/user/:user_id", GroupController, :get_group_by_user
  scope "/groups" do
    pipe_through :checkManagerOrAdminRole
    delete "/:id", GroupController, :delete
    put "/:id", GroupController, :update
    post "/", GroupController, :create    # Créer un groupe

      # Routes pour gérer les utilisateurs dans les groupes
  post "/:group_id/users/:user_id", GroupController, :add_user    # Ajouter un utilisateur à un groupe
  delete "/:group_id/users/:user_id", GroupController, :remove_user # Retirer un utilisateur d'un groupe
  end





  # routes pour les organisations
  scope "/organisations" do
    get "/", OrganisationController, :index
    get "/:id/users", OrganisationController, :users
    get "/:id", OrganisationController, :show
  end

  scope "/organisations" do
    pipe_through :checkManagerOrAdminRole
    post "/", OrganisationController, :create
    delete "/:id", OrganisationController, :delete
    put "/:id", OrganisationController, :update
    put "/:organisation_id/users/:user_id/:role_id", OrganisationController, :update_user_role
    delete "/:organisation_id/users/:user_id", OrganisationController, :remove_user
    post "/:organisation_id/users", RoleController, :add_user_to_organisation
  end

  scope "/roles" do
    get "/", RoleController, :show
  end

  #Routes pour l'authentification
  scope "/" do
    pipe_through :checkManagerOrAdminRole
    post "/register", AuthController, :register  # Route pour l'inscription
  end
  post "/login", AuthController, :login        # Route pour la connexion
  post "/decrypt_token", AuthController, :decrypt_token  # Route pour décrypter le token
  put "/update_password/:id", AuthController, :update_password




  end
end
