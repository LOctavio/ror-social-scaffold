Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :friendships
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  get '/requests', to: 'users#friend_requests_received'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
