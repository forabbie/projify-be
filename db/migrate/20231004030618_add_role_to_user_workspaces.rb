class AddRoleToUserWorkspaces < ActiveRecord::Migration[7.0]
  def change
    add_column :user_workspaces, :role, :string
  end
end
