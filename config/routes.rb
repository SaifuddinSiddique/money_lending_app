Rails.application.routes.draw do
  devise_for :users

  get "user_dashboard", to: "users#dashboard"
  get 'wallet_transactions/wallet_history', to: 'wallet_transactions#wallet_history'

  namespace :admin do
    resources :loans do
      post :approve, on: :member
      post :reject, on: :member
      get :edit, on: :member
      patch :update, on: :member
    end
  end

  resources :loans, only: [ :new, :create, :show ] do
    post :confirm, on: :member
    post :accept_adjustment, on: :member
    post :reject_adjustment, on: :member
    post :request_readjustment, on: :member
    post :repay, on: :member
    post :confirm_approval, on: :member
    post :reject_approval, on: :member
  end

  root "users#dashboard"
end
