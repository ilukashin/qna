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

  delete "delete_file/:id", to: 'attachments#delete_attached_file', as: 'delete_attached_file'
end
