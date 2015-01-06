class AddSingleQuestionSelectToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :single_question_select, :boolean
  end
end
