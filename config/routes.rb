Rails.application.routes.draw do
  default_url_options :host => "http://jarmodev:3011"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies
  resources :genres
  resources :videos
end
