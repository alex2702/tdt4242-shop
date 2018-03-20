Rails.application.routes.draw do

  namespace :admin do
    resources :users
    resources :products
    resources :carts
    resources :cart_items
    resources :orders
    resources :order_items
    resources :deals
    resources :product_items
    resources :messages
    root to: "users#index"
  end

  resources :products do
    get :manage, on: :collection, as: :manage
    patch :update_stock, on: :collection, as: :update_stock
  end
  root to: 'products#index'
  devise_for :users
  resources :users
  resources :carts
  get 'cart' => 'carts#show'
  resources :cart_items
  post 'addtocart' => 'cart_items#add_to_cart'
  resources :orders do
    get :checkout, on: :collection, as: :checkout
    get :manage, on: :collection, as: :manage
  end
  resources :order_items
  resources :deals
  resources :messages
end
