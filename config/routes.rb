Rails.application.routes.draw do
  resources :videos
  if ENV['SWAGGER_DOCUMENTATION'].present?
    mount Rswag::Api::Engine => '/api-docs'
    mount Rswag::Ui::Engine => '/api-docs'
  end

  namespace :api do
    namespace :v1 do
      resources :devices, only: %i[create update]
      resources :looks
      resource  :global_search, only: [:create], controller: :global_search
      resource  :password_reset, only: [:create], controller: :password_reset
      resources :tags
      resources :terms, only: [:index]
      resources :subscriptions, only: [:create, :update, :show]
      resources :terms_acceptances, only: %i[create show]
      resources :users, only: %i[create update show]
      resource  :user_token, only: [:create], controller: :user_token
    end
  end

  resources :passwords, only: %i[edit update]
end
