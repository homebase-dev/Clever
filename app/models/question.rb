class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator, :class_name => "User"

  has_many :answers, :dependent => :destroy
  has_many :assignations
  has_many :tests, :through => :assignations
  
  scope :published, -> { where(published: true) }
  
  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc { |attributes| attributes[:text].blank? }
  
  
  
  def created_at_formatted
    if created_at
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end

end
