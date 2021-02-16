Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :boards do
    resources :reservations, only: [ :new, :create ]
  end

  resources :users, only: [ :show ] do
    resources :reservations, only: [ :show, :index ]
  end

  resources :reservations, only: [ :update, :edit ] do
    resources :reviews, only: [ :create ]
  end
end
