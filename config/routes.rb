Rails.application.routes.draw do
  post 'users/image'
  root to: 'posts#index'
  resources :posts
  resources :tags
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
