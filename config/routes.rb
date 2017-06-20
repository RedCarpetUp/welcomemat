Rails.application.routes.draw do
  post '/emailin', to: 'emailin#index'
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
        post '/applicant_messages/to_applicant', to: 'applicant_messages#create_to_applicant', as: 'applicant_messages_to_applicant'
        post '/applicant_messages/to_collaborators', to: 'applicant_messages#create_to_collaborators', as: 'applicant_messages_to_collaborators'
        resources :templates, only: [:create]
        resources :extra_applicant_emails, only: [:create]
        post '/extra_applicant_emails/:id/grey', to: 'extra_applicant_emails#grey', as: 'extra_applicant_emails_grey'
        post '/extra_applicant_emails/:id/ungrey', to: 'extra_applicant_emails#ungrey', as: 'extra_applicant_emails_ungrey'
        post '/change_status/:status', to: 'applications#change_status', as: 'change_status'
      end
    end
    post '/jobs/:id/mail_multiple', to: 'jobs#mail_multiple', as: 'job_mail_multiple'
  end

end
