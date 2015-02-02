class CreateTestWorkflows < ActiveRecord::Migration
  def change
    create_table :test_workflows do |t|
      t.string :name

      t.timestamps
    end
  end
end
