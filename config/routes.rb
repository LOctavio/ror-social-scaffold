Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :friendships
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  get 'requests', to: 'users#friend_requests', as: :requests
  patch 'update_friendship', to: 'friendships#update'
  post 'send_friendship_request', to: 'friendships#create'
  delete 'delete_request', to: 'friendships#destroy'
end
