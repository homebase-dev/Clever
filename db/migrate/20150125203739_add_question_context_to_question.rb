class AddQuestionContextToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions, :question_context, index: true
  end
end
