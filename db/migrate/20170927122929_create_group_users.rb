class CreateGroupUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_users do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
