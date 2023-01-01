Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # resources :weeks, only: [:show]
  get '/pick', to: 'weeks#show'

  namespace :api do
  end

  # Defines the root path route ("/")
  root "season#index"
end
