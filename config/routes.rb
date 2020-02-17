Rails.application.routes.draw do
  devise_for :api_users, controllers: { sessions: 'api_users/sessions', registrations: 'api_users/registrations' }
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords' } 

  devise_scope :user do
    get 'users/check', to: 'users/sessions#check', as: 'user_check_token'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
