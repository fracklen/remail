Rails.application.routes.draw do
  devise_for :users
  devise_for :administrators
  root to: 'welcome#index'


  namespace :admin do
    resources :customers
    resources :users
  end

  namespace :users do
    resources :recipient_lists
    resources :recipient_list_uploads
    resources :domains
    resources :campaigns
  end

end
