class TaskSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :notes, :owner, :project_id, :deadline

  attribute :created_at do |task|
    task.created_at.strftime('%m-%d-%Y %H:%M')
  end

  attribute :status do |task|
    task.task_status.id
  end

  attribute :priority do |task|
    task.task_priority.id
  end

  attribute :owner_email do |task|
    task.user&.email
  end

  attribute :name do |task|
    user = task.user
    "#{user&.first_name} #{user&.last_name}".strip if user
  end
end