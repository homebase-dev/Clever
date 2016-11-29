class Novelty < ActiveRecord::Base
  scope :published, -> { where(published: true) }
  
  mount_uploader :image, ImageUploader
  
  def to_param
    "#{id} #{title}".parameterize
  end
    
end
