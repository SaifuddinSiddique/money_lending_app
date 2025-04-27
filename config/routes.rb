Rails.application.routes.draw do
  get "loans/new"
  get "loans/show"
  get "loans/confirm"
  get "loans/accept"
  get "loans/reject"
  get "loans/request_readjustment"
  get "loans/repay"
  devise_for :users
  
  get 'user_dashboard', to: 'users#dashboard'
  
  namespace :admin do
    resources :loans do
      post :approve, on: :member
      post :reject, on: :member
      get :edit, on: :member  # adjust loan
      patch :update, on: :member
    end
  end

  resources :loans, only: [:new, :create, :show] do
    post :confirm, on: :member
    post :accept_adjustment, on: :member
    post :reject_adjustment, on: :member
    post :request_readjustment, on: :member
    post :repay, on: :member
  end

  root "users#dashboard"
end
