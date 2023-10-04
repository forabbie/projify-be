Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'projects/index'
      get 'projects/create'
      get 'projects/update'
      get 'projects/destroy'
      get '/user/index'
      get '/users/current', to: 'users#active_user'
      get '/workspaces/all', to: 'workspaces#all_workspace'
      resources :workspaces do
        resources :projects do
          # get 'users', on: :user
          put 'add_user', on: :member  
        end
      end
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
