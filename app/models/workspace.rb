class Workspace < ApplicationRecord
  belongs_to :user
  validates_presence_of :name

  # def self.create_new_workspace(workspace_params)
  #   workspace = Workspace.new(workspace_params)
  #   if workspace.save
  #     return workspace
  #   else
  #     return nil
  #   end
  # end
end
