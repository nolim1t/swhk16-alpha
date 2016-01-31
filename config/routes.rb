Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/new' => 'cards#new', as: :cards_new
  get '/cards/detail' => 'carddetail#index', as: :carddetail_index
  get '/cards/transfer' => 'cards/transfer', as: :cards_transfer
  get '/cards/transferred' => 'cards/transferred', as: :cards_transferred
  
  match '/login' => 'login#login', :via => [:post]
  get '/sign_up' => 'login#logup', as: :logup
end
