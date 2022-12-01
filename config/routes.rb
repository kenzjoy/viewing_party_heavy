Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#landing'

  resources :users, only: [:show, :create] do
    resources :movies, only: [:index]
  end

  get '/register', to: 'users#new', as: 'new_user'
  get '/users/:id/discover', to: 'users#discover', as: 'discover'
end
