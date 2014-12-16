class Category < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :quiz
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
  
end
