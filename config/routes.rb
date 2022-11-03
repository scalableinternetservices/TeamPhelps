Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#index"
  resources :users
  get "/login", to: "users#index"
  post "/login", to: "users#login"
  get "/signup", to: "users#new"
end
