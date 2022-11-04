Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#index"
  resources :users
  get "/login", to: "users#index"
  post "/login", to: "users#login"
  get "/signup", to: "users#new"


  resources :courses do
    resources :posts
  end

  # resources :posts
  # get "/courses/:id/posts", to: "courses#posts#index"
  # post "/courses/:id/posts/new", to: "courses#posts#new"


  # post "/posts/new", to: "posts#new"
end
