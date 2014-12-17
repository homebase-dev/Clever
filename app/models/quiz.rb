class Quiz < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  scope :published, -> { where(published: true) }
  
  mount_uploader :image, ImageUploader
  
  has_many :categories, :dependent => :destroy
  
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
  
end
