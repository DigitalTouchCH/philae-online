Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"


  resources :firms
  resources :patients, only: [:index]
  resources :users, only: [:index]
  resources :therapists do
    get 'all_events', on: :member, defaults: { format: :json }
    member do
      patch :update_event
    end
  end
  resources :week_availabilities do
    resources :time_blocks
  end

end
