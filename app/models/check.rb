class Check < ActiveRecord::Base
  belongs_to :assignation
  belongs_to :answer
  
  #dont allow to store pairs twice (redundant)
  validates :assignation_id, :uniqueness => { :scope => :answer_id }
end
