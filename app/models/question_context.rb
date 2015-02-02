class QuestionContext < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator
  belongs_to :test_workflow
  
  has_many :questions, :dependent => :destroy
      
  scope :published, -> { where(published: true) }
  
  before_create :set_default_test_workflow

  private
  def set_default_test_workflow
    self.test_workflow ||= TestWorkflow.find_by_name('context_not_visible')
  end
  
end
