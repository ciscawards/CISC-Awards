Rails.application.routes.draw do

  root   'application#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  resources :users
  resources :cohorts
  resources :submissions do
    post :single_download, on: :member
    get :unsubmit, on: :member
  end
  post '/bulk_actions', to: 'submissions#bulk_actions'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
