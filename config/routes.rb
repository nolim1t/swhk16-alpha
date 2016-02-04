Rails.application.routes.draw do
  # Custom pathnames
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :edit => "settings" }, :controllers => {:registrations => "registrations"}

  # Default to cards index
  root to: "cards#index"

  # Real Pages
  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/edit/:id' => 'cards#edit', as: :cards_edit
  get '/cards/new' => 'cards#new', as: :cards_new_url
  post '/cards/new' => 'cards#newform', as: :cards_post_url
  get '/cards/detail/:id' => 'cards#detail', as: :cards_detail_url
  post '/cards/detail/:id' => 'cards#detail', as: :cards_detail_post_url
  # Fake pages
  get '/cards/transfer' => 'cards/transfer', as: :cards_transfer
  get '/cards/transferred' => 'cards/transferred', as: :cards_transferred
  get '/swhome' => 'home#index'
  match '/old/login' => 'login#login', :via => [:post]
  get '/old/sign_up' => 'login#logup', as: :logup
end
