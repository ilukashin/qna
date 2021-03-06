require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, path_names: { sign_in: :login, sign_out: :logout },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }
  post '/oauth_email_confirmation', to: 'users#oauth_email_confirmation'
  root 'questions#index'
  get '/search' => 'search#search'

  concern :votable do
    member do
      patch :up
      patch :down
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do

    resources :answers, concerns: %i[votable commentable], shallow: true do
      member do
        post :best
      end
    end

    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: [:create, :show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create destroy update] do
        resources :answers, only: %i[index show create destroy update], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
