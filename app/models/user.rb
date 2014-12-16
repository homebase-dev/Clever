class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :role
  
  before_create :set_default_role
  
  accepts_nested_attributes_for :role

  def fullname
    try(:firstname) + ' ' + try(:lastname)
  end

  def role_name
    role.try(:name)
  end
  
  def can_manage?
    admin? || moderator?
  end
  
  def moderator?
    role_name == 'moderator'
  end
  
  def admin?
    role_name == 'admin'
  end
  
  def banned?
    role_name == 'banned'
  end
  
  def member?
    role_name == 'member'
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
  
end
