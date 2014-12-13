class Faq < ActiveRecord::Base
  scope :published, -> { where(published: true) }
end
