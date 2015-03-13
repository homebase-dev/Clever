class QuestionContext < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator
  belongs_to :test_workflow
  
  has_many :questions, :dependent => :destroy
      
  scope :published, -> { where(published: true) }
  
  before_create :set_default_test_workflow, 
                :set_default_display_time_minutes



  def display_time_milliseconds
    milliseconds = 0
    
    if self.display_time_minutes.present?
      milliseconds = self.display_time_minutes * 60000
    end
    
    milliseconds
  end
  
  def countdown_date_in_milliseconds
    #(Time.now.to_f * 1000) 
    (DateTime.now.strftime('%Q').to_d + display_time_milliseconds).to_i
  end

  private
  
  def set_default_test_workflow
    self.test_workflow ||= TestWorkflow.find_by_name('context_not_visible')
  end
  
  def set_default_display_time_minutes
    self.display_time_minutes ||= 10
  end
  
end
