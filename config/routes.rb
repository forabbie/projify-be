Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/user/index'
      get '/users/current', to: 'user#active_user'
      resources :workspaces
      # resources :workspace
      # post '/workspace'
    end
  end
  devise_for :users, path: '', path_names: {
    sign_in: '/api/v1/auth/signin',
    sign_out: '/api/v1/auth/signout',
    registration: '/api/v1/signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
