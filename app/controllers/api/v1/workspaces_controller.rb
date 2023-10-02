class Api::V1::WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def index
    @workspace = Workspace.all
    render json: @workspace
  end

  def create
    # workspace = current_user.workspaces.build(workspace_params)
    # if workspace.save
    #   render json: {
    #     status: {
    #       code: 200,
    #       message: 'Workspace created successfully.'
    #     },
    #     data: WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes]
    #   }
    # else
    #   render json: {
    #     status: {
    #       message: "Workspace couldn't be created successfully. #{workspace.errors.full_messages.to_sentence}"
    #     }
    #   }, status: :unprocessable_entity
    # end
    workspace = Workspace.new(workspace_params)
    # workspace.user = current_user.id
    if workspace.save
      render json: {
        status: {
          code: 200,
          message: 'Workspace created successfully.'
        },
        data: WorkspaceSerializer.new(workspace).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {
          message: "Workspace couldn't be created successfully. #{workspace.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end

  private
  def workspace_params
    params.require(:workspace).permit(:name, :user)
  end

end
