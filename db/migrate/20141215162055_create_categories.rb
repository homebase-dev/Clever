class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.references :creator, index: true
      t.references :quiz, index: true
      t.boolean :published

      t.timestamps
    end
  end
end
