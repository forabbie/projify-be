# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  
  private
  def respond_with(current_user, _opts = {})
    @user = current_user
    @workspaces = Workspace.where(user_id: @user.id)

    workspace_data = @workspaces.map do |workspace|
      workspace_attributes = WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes]
      workspace_attributes
    end

    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.'
      },
      data: { 
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
        workspace: { id: workspace_data[0] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end
    
  render json: {
    status: current_user ? 200 : 401,
    message: current_user ? 'Logged out successfully.' : "Couldn't find an active session."
  }, status: :ok
  end
end
