class TaskSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :notes, :owner, :project_id

  attribute :deadline do |task|
    task.created_at.strftime('%m-%d-%Y %H:%M')
  end

  attribute :task_status_name do |task|
    task.task_status.name
  end

  attribute :task_priority_name do |task|
    task.task_priority.name
  end
end