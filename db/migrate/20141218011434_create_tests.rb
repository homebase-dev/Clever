class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.references :testee, index: true
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
