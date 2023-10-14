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
      post '/invitations/decline' => 'invitations#decline_invitation'
      resources :workspaces do
        get '/:data_type', to: 'workspaces#workspace_data', constraints: { data_type: /(members|projects)/ }
        resources :projects, only: [:create, :index] do
          post 'add_user', on: :member
        end
        resources :invitations, only: [:create, :index]                  
        post '/invitations/send' => 'invitations#send_invitation'
      end
    end
  end
  devise_for :users, path: '', path_names: {
    sign_in: '/auth/signin',
    sign_out: '/auth/signout',
    registration: '/signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
