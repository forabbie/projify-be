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
        # get '/:data_type', to: 'workspaces#workspace_data', constraints: { data_type: /(members|projects)/ }
        get '/members', to: 'workspaces#workspace_members'
        resources :projects, only: [:create, :show, :update, :index] do
          post '/add-member' => 'projects#add_member', on: :member  
          patch '/role-member' => 'projects#update_member_role', on: :member  
          delete '/remove-member' => 'projects#remove_member', on: :member  
          resources :tasks, only: [:create, :show, :update, :index] 
        end
        resources :invitations, only: [:create, :index]                  
        post '/invitations/send' => 'invitations#send_invitation'
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
