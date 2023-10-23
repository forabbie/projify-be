class Task < ApplicationRecord
  belongs_to :task_priority
  belongs_to :task_status
  belongs_to :project
  belongs_to :user, foreign_key: :owner
  # belongs_to :project, class_name: 'Project', foreign_key: 'project_id'

end
