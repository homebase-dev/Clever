class CreateQuestionContexts < ActiveRecord::Migration
  def change
    create_table :question_contexts do |t|
      t.text :content
      t.references :category, index: true
      t.references :creator, index: true
      t.boolean :published

      t.timestamps
    end
  end
end
