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
  # session
  get "/sign-in", to: "session#sign_in", as: 'sign_in'
  post "/sign-in", to: "session#login"
  get "/sign-up", to: "session#sign_up"
  get "/sign-out", to: "session#logout"
  get "/reset-password", to: "session#reset_password"
  get '/auth/:provider/callback', to: 'session#google_oauth2'
  get '/auth/failure', to: 'session#failure'
  get '/session', to: 'session#get_session'
  # Defines the root path route ("/")
  # root "posts#index"
  get "/tickets", to: "welcome#show"
  post "/sign-in", to: "welcome#sign_in"
  # 404
  get '*path', to: 'application#not_found', constraints: ->(request) { !request.path.match?(/\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)/) }
end
