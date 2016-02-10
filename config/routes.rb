Rails.application.routes.draw do
  # Custom pathnames
  devise_for :user, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :edit => "settings" }, :controllers => {:registrations => "registrations"}

  # Default to cards index
  root to: "cards#index"

  # Real Pages
  get '/cards/index' => 'cards#index', as: :cards_index
  get '/cards/edit/:id' => 'cards#edit', as: :cards_edit
  post '/cards/edit/:id' => 'cards#detail', as: :cards_edit_post_url
  get '/cards/new' => 'cards#new', as: :cards_new_url
  post '/cards/new' => 'cards#newform', as: :cards_post_url
  get '/cards/detail/:id' => 'cards#detail', as: :cards_detail_url
  post '/cards/detail/:id' => 'cards#detail', as: :cards_detail_post_url
  get '/cards/validate/:id' => 'cards#request_validation', as: :cards_validation_get_url

  # Vendor/Shopkeeper functionality
  get '/vendor' => 'cardverify#menu', as: :cardverify_menu
  get '/vendor/verify' => 'cardverify#index', as: :cardverify_index

  # Fake pages
  get '/cards/transfer' => 'cards/transfer', as: :cards_transfer
  get '/cards/transferred' => 'cards/transferred', as: :cards_transferred
  get '/swhome' => 'home#index'
  match '/old/login' => 'login#login', :via => [:post]
  get '/old/sign_up' => 'login#logup', as: :logup
end
