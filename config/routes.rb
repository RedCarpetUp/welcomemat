Rails.application.routes.draw do
  devise_for :users
  #namespace :api, defaults: {format: :json} do
  #  namespace :v1 do
  #    resources :organisations, only: [:create, :show, :index, :update, :destroy] do
  #      resources :jobs, only: [:create, :show, :index, :update, :destroy] do
  #        resources :applications, only: [:show, :index, :create]
  #      end
  #    end
  #  end
  #end

  #resources :organisations, only: [:show, :index] do
  #  resources :jobs, only: [:show, :index] do
  #    resources :applications, only: [:new, :create]
  #  end
  #  get 'dashboard', to: 'dashboard#index'
  #  get 'dashboard/*other', to: 'dashboard#index'
  #end
  root to: "organisations#index"
  resources :organisations do
    resources :jobs do
      resources :applications, only: [:show, :index, :create, :new] do
        resources :applicant_messages, only: [:create]
      end
    end
  end

end
