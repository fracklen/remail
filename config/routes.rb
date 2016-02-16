Rails.application.routes.draw do
  devise_for :users
  devise_for :administrators
  root to: 'welcome#index'


  namespace :admin do
    resources :customers
  end

end
