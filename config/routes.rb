Rails.application.routes.draw do
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :edit => "settings" }

  root to: "home#index"

  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/new' => 'cards#new', as: :cards_new
  get '/cards/detail' => 'carddetail#index', as: :carddetail_index
  get '/cards/transfer' => 'cards/transfer', as: :cards_transfer
  get '/cards/transferred' => 'cards/transferred', as: :cards_transferred

  match '/old/login' => 'login#login', :via => [:post]
  get '/old/sign_up' => 'login#logup', as: :logup
end
