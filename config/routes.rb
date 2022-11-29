Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#index"
  resources :users
  get "/login", to: "users#index"
  post "/login", to: "users#login"
  get "/signup", to: "users#new"
  get "/logout", to: "users#logout"
  get "/courses/:id/join", to: "courses#join", as: :join_course
  get "/courses/:id/leave", to: "courses#leave", as: :leave_course
  get "/courses/:id/new_student", to: "roles#new"
  get "/courses/:id/remove_student", to: "roles#remove_student"

  resources :courses do
    resources :posts do
      resources :comments, only: [:edit, :show, :create, :update, :destroy, :new]
    end
  end

  # resources :users do
  #   get '/page/:page', action: :index, on: :collection
  # end

  post "/courses/:course_id/posts/new", to: "posts#create"
  post "/courses/:course_id/posts/:post_id/comments/new", to: "comments#create"
  post "/courses/:id/new_student", to: "roles#create", as: :new_student_course


end
