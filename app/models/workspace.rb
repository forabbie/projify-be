class Workspace < ApplicationRecord
  belongs_to :user
  has_many :projects
  has_many :invitations
  has_many :user_workspaces
  has_many :users, through: :user_workspaces
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
