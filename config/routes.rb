Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  get 'comments/create'
  get 'comments/destroy'
  # Devise（管理者は登録/パスワード機能なし）
  devise_for :admins, path: 'admin', skip: [:registrations, :passwords]
  devise_for :users

  # 一般ページ
  root to: "homes#top"
  get "homes/about"
  get "shops", to: "shops#index", as: :shops

  # 管理画面
  namespace :admin do
    root to: "dashboard#index"
    resources :users,    only: [:index, :edit, :update, :destroy]
    resources :genres,   only: [:index, :new, :create, :edit, :update, :destroy]
    resources :comments, only: [:index, :destroy]
  end

  # 投稿
  resources :posts do
    collection do
      get :search
      get :my
    end
    member do
      get :likers
    end
    resources :likes,    only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  # ユーザー
  resources :users, only: [:show, :edit, :update] do
    member { get :likes }
  end
end