Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]
      get '/users/current' => 'users#active_user'
      get '/workspaces/all' => 'workspaces#all_workspace'
      get '/invitations' => 'invitations#sent_invitations'
      get '/invitations/validate' => 'invitations#validate_invitation'
      get '/projects/all' => 'projects#all_projects'
      post '/invitations/accept' => 'invitations#accept_invitation'
      resources :workspaces do
        resources :projects, only: [:create, :index] do
          # get 'users', on: :user
          post 'add_user', on: :member
        end
        post '/invitations/send' => 'invitations#send_invitation'
        resources :invitations, only: [:create, :index] do
          # post 'accept' => 'invitations#accept_invitation', on: :member
          post 'decline' => 'invitations#decline_invitation', on: :member
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
