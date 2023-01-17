Rails.application.routes.draw do
  # Devise
  devise_for :users

  # Letter Opener (development env only)
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Root
  root 'season#index'
  get 'season#index', to: redirect('/pick')

  # App routes
  # resources :weeks, only: [:show]
  get '/pick', to: 'weeks#show'

  # API routes
  namespace :api do
    namespace :v1 do
      post '/picks/:week_id' => 'user_picks#make_pick', as: :make_pick

      # Simulation routes (behind flag)
      if ENV['SIMULATION_MODE'].to_s.downcase == "true"
        patch '/simulate/advance' => 'simulation#advance_week', as: :sim_advance
        patch '/simulate/reset' => 'simulation#reset_simulation', as: :sim_reset
      end
    end
  end
end
