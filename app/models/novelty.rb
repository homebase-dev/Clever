class Novelty < ActiveRecord::Base
  scope :published, -> { where(published: true) }
  
  mount_uploader :image, ImageUploader
  
  def to_param
    "#{id} #{title}".parameterize
  end
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
    
end
