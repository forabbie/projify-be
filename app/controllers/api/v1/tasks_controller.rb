class Api::V1::TasksController < ApplicationController
  before_action :find_project
  before_action :find_task, only: [:show, :update, :destroy]
  before_action :require_project_membership, only: [:show, :update, :destroy]

  def index
    @tasks = @project.tasks
    task_data = TaskSerializer.new(@tasks).serializable_hash[:data][:attributes]
    render json: {
      status: { code: 200, message: 'Tasks retrieve successfully.' },
      data: task_data
    }
  end

  def show
    render json: @task
  end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    render json: { message: 'Task deleted successfully' }
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :notes, :owner, :task_priority_id, :task_status_id, :project_id)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_task
    @task = @project.tasks.find(params[:id])
  end

  def require_project_membership
    unless @project.members.include?(current_user)
      render json: { error: 'You do not have access to this project' }, status: :forbidden
    end
  end
end
