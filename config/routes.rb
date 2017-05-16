Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :organisations, only: [:create, :show, :index, :update, :destroy] do
        resources :jobs, only: [:create, :show, :index, :update, :destroy] do
          resources :applications, only: [:show, :index, :create]
        end
      end
    end
  end

  resources :organisations, only: [:show, :index] do
    resources :jobs, only: [:show, :index] do
      resources :applications, only: [:new, :create]
    end
    get 'dashboard', to: 'dashboard#index'
    get 'dashboard/*other', to: 'dashboard#index'
  end


end
