# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    authenticated :user do
      root 'home#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  devise_for :users, only: %i[sessions passwords invitations], controllers: {
    invitations: 'users/invitations'
  }

  scope format: :json do
    mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
      registrations: 'api/v1/registrations',
      sessions: 'api/v1/sessions',
      passwords: 'api/v1/passwords'
    }, as: 'api_v1_user'
  end

  resources :users
  resources :preferences, only: %i[index create new]
  resources :recipes, only: %i[index]

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: 'health#status'
      resources :impersonations, only: %i[create], constraints: Impersonation::EnabledConstraint.new
      devise_scope :user do
        resource :user, only: %i[update show]
      end
      resources :settings, only: [] do
        get :must_update, on: :collection
      end
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    authenticate(:admin_user) do
      mount Flipper::UI.app(Flipper) => '/feature-flags'
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
end
