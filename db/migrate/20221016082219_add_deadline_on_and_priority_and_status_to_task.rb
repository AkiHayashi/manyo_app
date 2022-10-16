class AddDeadlineOnAndPriorityAndStatusToTask < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.date :deadline_on, null: false
      t.integer :priority, null: false
      t.integer :status, null: false
    end 
  end
end
