class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
         
         
  belongs_to :role
  
  before_create :set_default_role
  
  accepts_nested_attributes_for :role

  has_many :tests #, foreign_key: "testee_id", class_name: "Test" 

  def fullname
    "#{try(:firstname)} #{try(:lastname)}"
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name   
      user.lastname = auth.info.last_name 
      #user.image = auth.info.image # assuming the user model has an image
    end
  end


  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
  
  
end
