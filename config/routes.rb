require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :users do
    resources :gmail_accounts
  end
  devise_for :users
  devise_for :administrators
  root to: 'welcome#index'

  mount Sidekiq::Web => '/sidekiq'

  namespace :admin do
    resources :customers
    resources :users
  end

  resources :links, only: [:show]

  get 'pixels/*id', to: 'pixels#show', constraints: { id: /[^\/]+/ }
  resources :unsubscriptions, only: [:new, :create]

  namespace :users do
    resources :dashboards, only: [:index]
    resources :recipient_lists
    resources :recipient_list_uploads
    resources :domains
    resources :mail_gateways
    resources :gmail_accounts
    resources :templates do
      member do
        get 'preview'
      end
    end
    resources :customer_stats do
        collection do
          get 'delivery_history'
          get 'open_history'
          get 'click_history'
        end
      end
    resources :campaigns do
      resources :campaign_stats do
        collection do
          get 'delivery_history'
        end
      end
      resources :campaign_runs, only: [:create, :destroy] do
        member do
          post 'resume'
          post 'cancel'
          post 'stop'
        end
      end
    end
  end

end
