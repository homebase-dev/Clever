class Test < ActiveRecord::Base
  belongs_to :testee, :class_name => "User"
  has_many :assignations
  has_many :questions, :through => :assignations
end
