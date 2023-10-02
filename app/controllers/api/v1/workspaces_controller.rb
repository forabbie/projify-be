class Api::V1::WorkspacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace, only: [:update]

  def index
    @workspace = Workspace.all
    render json: {
      status: {
        code: 200,
        message: 'Workspace retrieve successfully.'
      },
      data: @workspace.map { |workspace| WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes] }
    }
  end

  def create
    @workspace = current_user.workspace.build(workspace_params)

    if @workspace.save
      render json: {
        status: { code: 200, message: 'Workspace created successfully.' },
        data: WorkspaceSerializer.new(@workspace).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: "Failed to create workspace." }
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
        status: { message: "Failed to update workspace." }
      }, status: :unprocessable_entity
    end
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name, :user)
  end

  def set_workspace
    @workspace = Workspace.find(params[:id])
  end

end
