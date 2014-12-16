class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :text
      t.boolean :correct
      t.references :question, index: true
      t.references :creator, index: true
      t.boolean :published

      t.timestamps
    end
  end
end
