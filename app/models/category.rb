class Category < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :quiz
  
  #has_many :questions, :dependent => :destroy
  has_many :question_contexts, :dependent => :destroy
  
  scope :published, -> { where(published: true) }
  
  mount_uploader :image, ImageUploader
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
  
  def question_count
    question_count = 0
    
    question_contexts.each do |question_context| 
      question_count += question_context.questions.count
    end
    
    question_count
  end


end
