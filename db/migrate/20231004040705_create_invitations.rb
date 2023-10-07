class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :recipient_email
      t.string :token
      t.boolean :accepted
      t.references :workspace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
