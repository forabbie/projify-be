class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_workspace_membership, only: [:create, :update]

  def index
    user = current_user
    selected_workspace = Workspace.find(params[:workspace_id])

    user_projects_in_workspace = user.user_projects.where(project_id: selected_workspace.projects.pluck(:id))
    projects_in_workspace = user_projects_in_workspace.map(&:project) 

    render json: {
      status: { code: 200, message: 'Projects retrieved successfully.' },
      data: projects_in_workspace.map { |project| ProjectSerializer.new(project).serializable_hash[:data][:attributes] }
    }
  end

  def show
    @user = current_user
    @workspace = Workspace.find(params[:workspace_id])
    workspace_attributes = WorkspaceSerializer.new(@workspace).serializable_hash[:data][:attributes]
    is_creator = (@workspace.user == @user)
    workspace_attributes[:is_creator] = is_creator

    @projects = @workspace.projects
    project_details = []

    project = Project.find(params[:id])
    project_data = project.attributes
    project_users = User.joins(user_projects: :project)
                      .where('projects.id = ?', project.id)
                      .select(:id, :first_name, :last_name, :email, 'user_projects.role AS role')
    project_data["members"] = project_users
    project_details << project_data

    render json: {
      status: { code: 200, message: 'Workspace projects retrieved successfully.' },
      data: {
        workspace: workspace_attributes,
        project: project_details
      }
    }
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
    @project = Project.find(params[:id])

    if @project.update(project_params)
      render json: { message: 'Project updated successfully' }
    else
      render json: { error: 'Failed to update project', errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def all_projects
    @project = Project.all
    render json: {
      status: {
        code: 200,
        message: 'Projects retrieve successfully.'
      },
      data: @project.map { |project| ProjectSerializer.new(project).serializable_hash[:data][:attributes] }
    }
  end

  def add_member
    @project = Project.find(params[:id])
    user_id = params[:user_id]
    role = params[:role]
  
    if @project.users.exists?(user_id)
      render json: { error: 'User is already a member of the project.' }, status: :unprocessable_entity
      return
    end
  
    user = User.find(user_id)
  
    user_project = UserProject.new(user: user, project: @project, role: role)
  
    if user_project.save
      render json: { message: 'User added to the project with role ' + role + ' successfully.' }
    else
      render json: { error: 'Failed to add the user to the project.' }, status: :unprocessable_entity
    end
  end
  

  def update_member_role
    @project = Project.find(params[:id])
    user_id = params[:user_id] # User whose role needs to be updated
  
    # Check if the user is a member of the project
    user = @project.users.find_by(id: user_id)
  
    if user.nil?
      render json: { error: 'User is not a member of the project.' }, status: :unprocessable_entity
      return
    end
  
    new_role = params[:role] # New role to assign to the user
  
    # Update the role for the user within the project
    user_project = UserProject.find_by(user_id: user_id, project_id: @project.id)
  
    if user_project
      user_project.update(role: new_role)
      render json: { message: 'User role updated successfully.' }
    else
      render json: { error: 'User is not a member of the project.' }, status: :unprocessable_entity
    end
  end
  
  
  def remove_member
    @project = Project.find(params[:id])
    user_id = params[:user_id]
  
    user = @project.users.find_by(id: user_id)
  
    if user.nil?
      render json: { error: 'User is not a member of the project.' }, status: :unprocessable_entity
      return
    end
  
    @project.users.delete(user)
  
    user_project = UserProject.find_by(user_id: user_id, project_id: @project.id)
    user_project.destroy if user_project
  
    render json: { message: 'User removed from the project successfully.' }
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

  def authorize_workspace_membership
    @workspace = Workspace.find(params[:workspace_id])
  
    user_workspace = UserWorkspace.find_by(workspace: @workspace, user: current_user)
  
    unless user_workspace && user_workspace.role == 'admin'
      render json: { error: 'You are not authorized to create or update a project in this workspace.' }, status: :forbidden
    end
  end
  
end
