Rails.application.routes.draw do
  root 'application#index'
  get 'welcome' => 'application#welcome', as: :welcome
  get 'all' => 'application#all', as: :all
  get 'custom' => 'application#custom', as: :custom
  get 'set_link_behavior' => 'application#set_link_behavior', as: :set_link_behavior

  get 'session' => 'sessions#show'
  get 'clear_session' => 'sessions#clear_session', as: :clear_session
  get 'add_source' => 'sessions#add_source', as: :add_source
  get 'log' => 'sessions#log', as: :log
  get 'share_path' => 'sessions#share', as: :share
  get 'clear_path' => 'sessions#clear', as: :clear
  get 'add_trello_story/:id' => 'sessions#add_trello_story', as: :add_trello_story
  match 'trello' => 'sessions#trello', via: [:get, :post], as: :trello

  match "feedback" => "application#feedback", via: [:get, :post], as: :feedback

  get '/:session' => 'application#index'
end
