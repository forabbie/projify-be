class AddDescriptionToWorkspaces < ActiveRecord::Migration[7.0]
  def change
    add_column :workspaces, :description, :string
  end
end
