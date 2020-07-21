Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: :login, sign_out: :logout }
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
