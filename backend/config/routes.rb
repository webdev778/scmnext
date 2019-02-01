Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/auth', to: 'user_sessions#show'
  scope :v1, defaults: { format: :json } do
    resources :users
    resources :balancing_groups
    resources :companies
    resources :districts
    resources :consumers
    resources :facilities

    namespace :dlt do
      resources :files
    end

    get "power_usages/:type", to: "power_usages#show", constraints: { type: /(fixed|preliminaly)/ }
  end
end
