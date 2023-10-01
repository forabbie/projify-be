class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :details
      t.datetime :expected_completion_date
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
