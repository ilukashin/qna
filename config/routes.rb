Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: :login, sign_out: :logout }
  root 'questions#index'

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
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create

  mount ActionCable.server => '/cable'
end
