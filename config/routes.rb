Rails.application.routes.draw do
  get "welcome/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # site
  root "site#home"
  get "/contact", to: "site#contact", as: 'home'
  get "/privacy", to: "site#privacy", as: 'privacy'
  get "/terms-and-conditions", to: "site#terms", as: 'terms'
  get "/about", to: "site#about", as: 'about'
  # admin
  resources :specialisms
  get "/specialisms", to: "specialisms#index", as: 'specialisms_index'
  get "/specialisms/:id/delete", to: "specialisms#delete", as: 'specialisms_delete'
  get "/specialisms/:id/edit", to: "specialisms#edit", as: 'specialisms_edit'
  get "/specialisms/new", to: "specialisms#new", as: 'specialisms_new'
  post "/specialisms", to: "specialisms#create", as: 'specialisms_create'
  post "/specialisms/:id", to: "specialisms#update", as: 'specialisms_update'
  resources :mentors
  get "/mentors", to: "mentors#index", as: 'mentors_index'
  get "/mentors/:id/delete", to: "mentors#delete", as: 'mentors_delete'
  get "/mentors/:id/edit", to: "mentors#edit", as: 'mentors_edit'
  get "/mentors/new", to: "mentors#new", as: 'mentors_new'
  post "/mentors", to: "mentors#create", as: 'mentors_create'
  post "/mentors/:id", to: "mentors#update", as: 'mentors_update'
  post '/mentors/:mentor_id/specialisms', to: 'mentors#update_specialisms', as: 'update_mentor_specialisms'
  # session
  get "/sign-in", to: "session#sign_in", as: 'sign_in'
  post "/sign-in", to: "session#login"
  get "/sign-up", to: "session#sign_up"
  get "/sign-out", to: "session#logout"
  get "/reset-password", to: "session#reset_password"
  get '/auth/:provider/callback', to: 'session#google_oauth2'
  get '/auth/failure', to: 'session#failure'
  get '/session', to: 'session#get_session'
  get '/tokens', to: 'session#tokens'
  # Defines the root path route ("/")
  # root "posts#index"
  get "/tickets", to: "welcome#show"
  post "/sign-in", to: "welcome#sign_in"
  # admin
  get "/tickets", to: "welcome#show"
  # 404
  get '/404', to: 'application#not_found', as: 'not_found'
  match "*unmatched_route", to: "application#not_found", via: :all
end
