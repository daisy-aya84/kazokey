class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :memo
      t.boolean :complete
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
