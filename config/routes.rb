Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :firms

  resources :services, only: [:index, :show, :new, :create, :edit, :update]

  resources :patients, only: [:index, :show, :new, :create, :edit, :update] do
    get 'patients/:id/events', to: 'patients#events', as: :patient_events
  end

  resources :ordonnances, only: [:new, :create, :edit, :update, :show]

  resources :users, only: [:index, :edit, :update]

  resources :therapists do
    get 'all_events', on: :member, defaults: { format: :json }
    member do
      patch :update_event
    end
  end

  resources :week_availabilities do
    resources :time_blocks
  end

  resources :event_individuels do
    member do
      patch :update_status
      patch :associate_ordonnance
    end
  end

end
