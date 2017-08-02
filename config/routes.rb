Rails.application.routes.draw do
  post '/emailin', to: 'emailin#index'
  post '/email_delivery', to: 'emailin#delivery'
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
  resources :o, :controller => :organisations, :as => :organisations, except: [:show] do
    resources :jobs do
      resources :applications, only: [:show, :index, :create, :new] do
        resources :applicant_messages, only: [:create]
        resources :templates, only: [:create]
        resources :extra_applicant_emails, only: [:create]
        post '/extra_applicant_emails/:id/grey', to: 'extra_applicant_emails#grey', as: 'extra_applicant_emails_grey'
        post '/extra_applicant_emails/:id/ungrey', to: 'extra_applicant_emails#ungrey', as: 'extra_applicant_emails_ungrey'
        post '/change_status/:status', to: 'applications#change_status', as: 'change_status'
        post '/move_application', to: 'applications#move_application', as: 'move_application'
      end
      resources :collaborators, only: [:index, :create, :destroy]
    end
    post '/jobs/:id/mail_multiple', to: 'jobs#mail_multiple', as: 'job_mail_multiple'
  end

end
