Rails.application.routes.draw do
  get "welcome/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # session
  get "/sign-in", to: "session#sign_in", as: 'sign_in'
  post "/sign-in", to: "session#login"
  get "/sign-up", to: "session#sign_up"
  get "/reset-password", to: "session#reset_password"
  # Defines the root path route ("/")
  # root "posts#index"
  get "/tickets", to: "welcome#show"
  post "/sign-in", to: "welcome#sign_in"
  root "welcome#index"
  # 404
  get '*path', to: 'application#not_found', constraints: ->(request) { !request.path.match?(/\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)/) }
end
