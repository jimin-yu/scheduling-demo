require 'sidekiq/web' 
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :schedule, only: [:index, :update, :show], param: :date do
    collection do
      get 'events'
    end
  end

  resources :log, only: [:index]

end
