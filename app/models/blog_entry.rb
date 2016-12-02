class BlogEntry < ActiveRecord::Base
  belongs_to :user
  
  after_initialize :set_defaults
  
  scope :published, -> { where(published: true) }
  
  def to_param
    "#{id} #{title}".parameterize
  end
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end
  
  

  private
  
  def set_defaults
    self.published = true if published.nil?
  end
  
end
