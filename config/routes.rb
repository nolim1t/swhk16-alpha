Rails.application.routes.draw do
  root to: "home#index"

  get '/cards/index' => 'cards#index', as: :cards_index

  match '/login' => 'login#login', :via => [:post]
end
