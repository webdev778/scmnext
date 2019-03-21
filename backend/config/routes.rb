Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount_devise_token_auth_for 'User', at: 'auth'
  get '/auth', to: 'user_sessions#show'
  scope :v1, defaults: { format: :json } do

    concern :listable do
      collection do
        get 'list', action: 'list'
      end
    end
    concern :enumable do
      collection do
        get 'enums/:name', action: 'enums'
      end
    end

    resources :users, concerns: [:listable]
    resources :balancing_groups, concerns: [:listable]
    resources :bg_members, concerns: [:listable]
    resources :companies, concerns: [:listable]
    resources :discounts_for_facilities
    resources :districts, concerns: [:listable]
    resources :district_loss_rates, concerns: [:listable]
    resources :consumers, concerns: [:listable]
    resources :contracts, concerns: [:listable]
    resources :contract_items, concerns: [:listable]
    resources :contract_item_groups, concerns: [:listable]
    resources :contract_meter_rates, concerns: [:listable]
    resources :facilities, concerns: [:listable]
    resources :facility_groups, concerns: [:listable]
    resources :fuel_cost_adjustments, concerns: [:listable]
    resources :jbu_contracts, concerns: [:listable]
    resources :resources, concerns: [:listable]
    resources :time_indices, concerns: [:listable]
    resources :voltage_types, concerns: [:listable]
    resources :wheeler_charges, concerns: [:listable]
    resources :holidays, concerns: [:listable]

    namespace :dlt do
      resources :files, concerns: [:enumable]
      resources :settings, concerns: [:enumable]
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
