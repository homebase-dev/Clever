class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator, :class_name => "User"

  has_many :answers, :dependent => :destroy
  
  scope :published, -> { where(published: true) }
  
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end

end
