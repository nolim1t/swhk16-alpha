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
  get '/cards/cancelvalidation/:id' => 'cards#cancelvalidation', as: :cards_validation_cancel_url
  get '/cards/delete/:id' => 'cards#deletecard', as: :cards_delete_url
  get '/cards/undelete/:id' => 'cards#undeletecard', as: :cards_undelete_url
  get '/cards/graveyard' => 'cards#graveyard', as: :cards_graveyard_url

  # Vendor/Shopkeeper functionality
  get '/vendor' => 'cardverify#menu', as: :cardverify_menu
  get '/vendor/verify' => 'cardverify#index', as: :cardverify_index
  get '/vendor/reject/:id' => 'cardverify#rejectcard', as: :cardverify_reject
  get '/vendor/accept/:id' => 'cardverify#acceptcard', as: :cardverify_accept
  # Expert user functionality
  get '/expert' => 'cardverify#menu', as: :cardverify_menu_expert

  # Transfer functionality
  post '/cards/transfer' => 'transfer#outbound', as: :cardtransfer_outbound
  get '/cards/transfer/reject/:id' => 'transfer#rejecttransfer', as: :cardtransfer_reject
  get '/cards/transfer/accept/:id' => 'transfer#acceptransfer', as: :cardtransfer_accept
  get '/cards/transfer/incoming' => 'transfer#inbound', as: :cardtransfer_inbound

  # Admin page
  get '/admin' => 'adminpage#index', as: :adminpage_index
  get '/admin/generateinvite' => 'adminpage#generateinvite', as: :adminpage_generateinvite
  get '/admin/users' => 'adminpage#userlist', as: :adminpage_userlist
  get '/admin/transfers' => 'adminpage#transferlist', as: :adminpage_transferlist
  get '/admin/usercards/:id' => 'adminpage#usercards', as: :adminpage_usercards
  
  # Fake pages
  get '/cards/transfer' => 'cards/transfer', as: :cards_transfer
  get '/cards/transferred' => 'cards/transferred', as: :cards_transferred
  get '/swhome' => 'home#index'
  match '/old/login' => 'login#login', :via => [:post]
  get '/old/sign_up' => 'login#logup', as: :logup
end
