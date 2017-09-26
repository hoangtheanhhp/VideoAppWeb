Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: [:create, :destroy]
  get 'sessions/push/:videouid', to: 'sessions#push', as: 'push'
  get 'sessions/drop/:videouid', to: 'sessions#drop', as: 'drop'
  resource :home, only: [:show]
  get 'home/ajax/:selectNum', to: 'home#ajax', as: 'ajax'
  resources :videos
  get 'videos/ban', to: 'videos#ban', as: 'ban'
  resources :users, only: [:show, :index]
  root 'home#show'
  get '/list/:index', to: 'list#index', as: 'list_videos'
  get '/users/admin/:id', to: 'users#admin', as: 'user_active'
end