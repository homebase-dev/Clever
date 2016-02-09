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
    
    return false if question.nil?
    
    question.answers.each do |answer|
      return false if !answer_passed?(answer)
    end
    return passed
  end
  
  def belongs_to_same_test?(assignation)
    same_tests = false
    
    if assignation.nil? || self.test.nil? || assignation.test.nil?
      return same_tests
    end
    
    same_tests = (self.test.id == assignation.test.id)
  end
  
  def belongs_to_different_test?(assignation)
    different_tests = !belongs_to_same_test?(assignation)
  end
  
  def belongs_to_same_context?(assignation)
    same_contexts = false

    if assignation && assignation.question && self.question
      same_contexts = true if (self.question.question_context == assignation.question.question_context)
    end
    
    same_contexts
  end
  
  def belongs_to_different_context?(assignation)
    different_contexts = !belongs_to_same_context?(assignation)
  end


end
