class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :assignation, index: true
      t.references :answer, index: true

      t.timestamps
    end
  end
end
