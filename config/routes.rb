Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: :login, sign_out: :logout }
  root 'questions#index'

  concern :votable do
    member do
      patch :up
      patch :down
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :comments, only: :create

    resources :answers, concerns: %i[votable], shallow: true do
      resources :comments, only: :create
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create

  mount ActionCable.server => '/cable'
end
