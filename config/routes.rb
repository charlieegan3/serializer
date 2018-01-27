Rails.application.routes.draw do
  root 'application#index'
  get 'about' => 'application#about'

  get 'session' => 'sessions#show'
  post 'add_source' => 'sessions#add_source'
  get 'log' => 'sessions#log', as: :log

  get 'all', to: redirect('/')
  get 'custom', to: redirect('/')

  get '/:session' => 'sessions#sync'
end
