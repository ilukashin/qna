Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: :login, sign_out: :logout }
  root 'questions#index'

  concern :votable do
    member do
      patch :up
      patch :down
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
