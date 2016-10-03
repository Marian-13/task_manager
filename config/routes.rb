Rails.application.routes.draw do
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'

  get  '/signup' => 'users#new'
  get  '/users'  => 'users#new'
  post '/users'  => 'users#create'

  resources :tasks
  post 'tasks/share'

  root 'sessions#new'
end
