Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"


  resources :firms, only: [:index]
  resources :users, only: [:index]
  resources :therapists, only: [:show] do
    get 'events', on: :member, defaults: { format: :json }
  end



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
