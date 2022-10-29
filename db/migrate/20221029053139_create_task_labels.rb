class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels, id: false do |t|
      t.belongs_to :task
      t.belongs_to :label
    end
  end
end
