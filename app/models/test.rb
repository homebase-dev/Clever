class Test < ActiveRecord::Base
  belongs_to :testee, :class_name => "User"
  has_many :assignations
  has_many :questions, :through => :assignations
  
  
  def passed_assignations
    count = 0;
    assignations.each do |a|
      count+=1 if a.passed?
    end
    count
  end
  
  
  def result_in_percent
    total = assignations.count 
    passed = passed_assignations
    result = (100 * passed) / total 
  end
  
  def duration_in_sec
    sec = nil
    
    if self.start.present? && self.end.present?
      sec = (self.end - self.start)#.strftime("%H:%M:%S")
    end
    
    sec
  end
  
  
end
