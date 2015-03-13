class TestWorkflow < ActiveRecord::Base
  has_many :question_contexts

  def always_visible?
    visible = false
    visible = true if self.name == 'context_always_visible'
    
    visible
  end

  def visible_at_beginning?
    visible_begin = false
    visible_begin = true if self.name == 'context_visible_at_beginning'
    
    visible_begin
  end

  def not_visible?
    not_visible = false
    not_visible = true if self.name == 'context_not_visible'
    
    not_visible
  end


end
