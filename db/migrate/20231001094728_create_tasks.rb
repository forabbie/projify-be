class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :deadline
      t.string :notes
      t.integer :owner
      t.references :task_priority, null: false, foreign_key: true
      t.references :task_status, null: false, foreign_key: true

      t.timestamps
    end
  end
end
