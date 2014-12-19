class Assignation < ActiveRecord::Base
  belongs_to :test
  belongs_to :question
  has_many :checks



  def answer_checked?(answer) 
    checks.exists?(:answer_id => answer.id)   
  end
  
  def answer_passed?(answer)
    passed = true
    was_checked = answer_checked?(answer)
    passed = false if (answer.correct? && !was_checked) || (!answer.correct? && was_checked)
    return passed
  end
  
  def passed?
    passed = true
    question.answers.each do |answer|
      return false if !answer_passed?(answer)
    end
    return passed
  end


end
