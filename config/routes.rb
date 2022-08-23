require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount Sidekiq::Web, at: "/sidekiq"

  namespace :api do
    resources :session, only: [], defaults: { format: :json } do
      collection do
        post :login
        post :logout
        post :refresh
      end
    end

    namespace :license do
      resources :files, only: [] do
        post :ingest, on: :collection
      end
    end
  end
end
