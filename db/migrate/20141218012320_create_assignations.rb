class CreateAssignations < ActiveRecord::Migration
  def change
    create_table :assignations do |t|
      t.references :test, index: true
      t.references :question, index: true

      t.timestamps
    end
  end
end
