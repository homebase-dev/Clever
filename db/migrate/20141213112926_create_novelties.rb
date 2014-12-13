class CreateNovelties < ActiveRecord::Migration
  def change
    create_table :novelties do |t|
      t.string :title
      t.text :text
      t.boolean :published
      t.integer :priority

      t.timestamps
    end
  end
end
