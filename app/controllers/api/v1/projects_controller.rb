class Api::V1::ProjectsController < ApplicationController
  before_action :authorize_workspace_membership, only: [:create, :update]

  def index
    @project = Project.all
    render json: {
      status: {
        code: 200,
        message: 'Projects retrieve successfully.'
      },
      data: @project.map { |project| ProjectSerializer.new(project).serializable_hash[:data][:attributes] }
    }
  end

  def show
  end

  def create
    @workspace = Workspace.find(params[:workspace_id])
    @project = @workspace.projects.build(project_params)

    if @project.save
      user_project = UserProject.new(user_id: current_user.id, project_id: @project.id, role: "admin")

      if user_project.save
        render json: {
          status: { code: 200, message: 'Project created successfully.' },
          data: @project
        }
      else
        render json: {
          status: { message: 'Failed to create project user association.' },
          errors: user_project.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: { message: 'Failed to create project.' },
        errors: @project.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end

  # def users
  #   @project_users = (@project.users + (User.where(tenant_id: @tenant.id, is_admin: true))) - [current_user]
  #   @other_users = @tenant.users.where(is_admin: false) - (@project_users + [current_user])
  # end

  def add_user
    @project = Project.find(params[:id])
    @user = User.find(params[:user_id])
    @project.users << @user

    if @project.save
      render json: {
        status: { code: 200, message: 'User was successfully added to the project.' },
        data: ProjectSerializer.new(@project).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: 'Failed to add user to the project.' },
        errors: @project.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :details, :expected_completion_date)
  end

  def set_workspace
    @workspace = Tenant.find(params[:workspace_id])
  end

  # def verify_workspace
  #   unless params[:workspace_id] == Tenant.current_workspace_id.to_s
  #   render json: {
  #     status: { message: "You are not authorized to access any organization other than your own" }
  #   }
  #   end
  # end

  def authorize_workspace_membership
    @workspace = Workspace.find(params[:workspace_id])

    unless @workspace.users.include?(current_user)
      render json: { error: 'You are not authorized to create a project in this workspace.' }, status: :forbidden
    end
  end
end
