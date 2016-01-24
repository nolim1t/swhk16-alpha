Rails.application.routes.draw do
  root to: "home#index"

  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/detail' => 'carddetail#index', as: :carddetail_index
  
  match '/login' => 'login#login', :via => [:post]
end
