Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  root "home#show"

  resource :dashboard, only: :show, controller: :dashboard
  resources :products, only: [:index, :show, :new, :create] do
    resources :departures, only: [:new, :create]
  end
  resources :bookings, only: [:index, :show, :new, :create] do
    resources :travelers, only: [:new, :create]
    resources :payments, only: [:new, :create]
  end
  resources :support_cases, only: [:index, :show, :new, :create] do
    resources :case_messages, only: :create
  end

  namespace :platform do
    resources :tenants, only: [:index, :new, :create]
  end
end
