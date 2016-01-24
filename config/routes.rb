Rails.application.routes.draw do
  root to: "home#index"

  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/new' => 'cards#new', as: :cards_new
  get '/cards/detail' => 'carddetail#index', as: :carddetail_index
  get '/cards/tracking' => 'cards/tracking', as: :cards_tracking
  
  match '/login' => 'login#login', :via => [:post]
  get '/sign_up' => 'login#logup', as: :logup
end
