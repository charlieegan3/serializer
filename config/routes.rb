Rails.application.routes.draw do
  root 'application#index'
  get 'about' => 'application#about'
  get 'feedback' => 'application#feedback', as: :feedback

  get 'add_trello_story/:id' => 'sessions#add_trello_story', as: :add_trello_story
  match 'trello' => 'sessions#trello', via: [:get, :post], as: :trello

  get 'session' => 'sessions#show'
  get 'add_source' => 'sessions#add_source', as: :add_source
  get 'log' => 'sessions#log', as: :log
  get '/:session' => 'sessions#sync'
end
