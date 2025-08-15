Rails.application.routes.draw do
  devise_for :users
 root to: "homes#top"
  get 'homes/about'

  
  
  resources :posts do
    collection do
      get :search
      get :my
    end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
end