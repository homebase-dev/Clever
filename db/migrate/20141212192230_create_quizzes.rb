class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.text :description
      t.references :creator, index: true
      t.boolean :published

      t.timestamps
    end
  end
end
