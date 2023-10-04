class Api::V1::WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workspace, only: [:update, :destroy]
  # before_action :authorize_owner, only: [:update, :destroy]
  before_action :authorize_update, only: [:update, :destroy, :authorize_update]

  def index
    @user = current_user
    @workspaces = @user.workspaces
    render json: {
      status: { code: 200, message: 'Workspace retrieve successfully.' },
      data: @workspaces.map { |workspace| WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes] }
    }
  end

  def create
    # puts "Current User: #{current_user.inspect}"
    # puts "Workspace Params: #{workspace_params.inspect}"
    # @workspace = current_user.workspaces.build(workspace_params)

    @workspace = Workspace.new(workspace_params)
    @workspace.user = current_user
    if @workspace.save
      user_workspace = UserWorkspace.create(workspace: @workspace, user: current_user, role: "admin")
      if user_workspace.save
        render json: {
          status: { code: 200, message: 'Workspace created successfully.' },
          data: WorkspaceSerializer.new(@workspace).serializable_hash[:data][:attributes]
        }
      else
        @workspace.destroy
        render json: {
          status: { message: 'Failed to create workspace user association.' },
          errors: user_workspace.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: { message: "Failed to create workspace." },
        errors: @workspace.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @workspace.update(workspace_params)
      render json: {
        status: { code: 200, message: 'Workspace updated successfully.' },
        data: WorkspaceSerializer.new(@workspace).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: "Failed to update workspace." },
        errors: @workspace.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def all_workspace
    @workspaces = Workspace.all
    render json: {
      status: {
        code: 200,
        message: 'Workspaces retrieve successfully.'
      },
      data: @workspaces.map { |workspace| WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes] }
    }
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name, :user)  
  end

  def find_workspace
    @workspace = Workspace.find(params[:id])
  end

  # def authorize_owner
  #   unless current_user && @workspace.user_id == current_user.id
  #     render json: {
  #       status: { message: 'Unauthorized. You do not have permission to update this workspace.' }
  #     }, status: :unauthorized
  #   end
  # end

  def authorize_update
    user_workspace = UserWorkspace.find_by(workspace_id: @workspace.id, user_id: current_user.id)
    unless user_workspace && user_workspace.role == 'admin'
      render json: {
        status: { message: 'Unauthorized. You do not have permission to update this workspace.' }
      }, status: :unauthorized
    end
  end
end
