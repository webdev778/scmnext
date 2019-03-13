Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/auth', to: 'user_sessions#show'
  scope :v1, defaults: { format: :json } do
    resources :users
    resources :balancing_groups do
      resources :bg_members
    end
    resources :bg_members
    resources :companies
    resources :districts
    resources :district_loss_rates
    resources :consumers
    resources :contracts
    resources :contract_items
    resources :contract_item_groups
    resources :contract_meter_rates
    resources :facilities
    resources :facility_groups
    resources :fuel_cost_adjustments
    resources :jbu_contracts
    resources :resources
    resources :time_indices
    resources :voltage_types
    resources :wheeler_charges
    resources :holidays

    namespace :dlt do
      resources :files
      resources :settings
      resources :usage_fixed_headers
    end

    namespace :jepx do
      resources :imbalance_betas
      resources :spot_trades
    end

    get "balancings", to: "balancings#show"
    get "power_usages/:type", to: "power_usages#show", constraints: { type: /(fixed|preliminary)/ }
    get "profits/:type", to: "profits#show", constraints: { type: /(fixed|preliminary)/ }
  end
end
