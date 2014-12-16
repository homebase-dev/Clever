class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.references :category, index: true
      t.references :creator, index: true
      t.boolean :published

      t.timestamps
    end
  end
end
