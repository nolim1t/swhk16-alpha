Rails.application.routes.draw do
  root to: "home#index"
  match '/login' => 'login#login', :via => [:post]
end
