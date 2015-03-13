class AddDisplayTimeMinutesToQuestionContexts < ActiveRecord::Migration
  def change
    add_column :question_contexts, :display_time_minutes, :decimal, precision: 5, scale: 2
  end
end
