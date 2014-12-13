class Quiz < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  scope :published, -> { where(published: true) }
  
  mount_uploader :image, ImageUploader
end
