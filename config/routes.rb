Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get '/users/login', to: 'users#login_form', as: 'user_login'
  post '/users/login', to: 'users#login_user'

  resources :users, only: [:show, :create] do
    resources :movies, only: [:index, :show] do
    end
  end

  get '/users', to: 'welcome#index'
  get '/register', to: 'users#new', as: 'new_user'
  get '/users/:id/discover', to: 'users#discover', as: 'discover'
  get '/users/:user_id/movies/:movie_id/viewing_party/new', to: 'parties#new', as: 'new_viewing_party'
  post '/users/:user_id/movies/:movie_id/viewing_party/create', to: 'parties#create'
end
