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

  post "/courses/:course_id/posts/new", to: "posts#create"

end
