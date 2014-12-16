class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :creator, :class_name => "User"

  scope :published, -> { where(published: true) }
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
  
end
