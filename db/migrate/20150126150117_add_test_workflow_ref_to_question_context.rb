class AddTestWorkflowRefToQuestionContext < ActiveRecord::Migration
  def change
    add_reference :question_contexts, :test_workflow, index: true
  end
end
