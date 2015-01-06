class AddSolutionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :solution, :text
  end
end
