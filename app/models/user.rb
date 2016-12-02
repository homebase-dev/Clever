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
  
  has_many :invoices
  
  has_many :blog_entries
  
  mount_uploader :avatar, ImageUploader

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
  
  def membership_expiration_date_formatted
    formatted_date = membership_expiration_date
    if formatted_date.present?
      formatted_date = membership_expiration_date.strftime("%d.%m.%Y")
    end
    formatted_date
  end
  
  def membership_expiration_date
    invoice = latest_successful_invoice
    return nil if invoice.blank?
    expiration_date = invoice.membership_expiration_date
    expiration_date
  end
  
  def membership_expired?
    membership_expired = true
    
    expiration_date = membership_expiration_date
    
    if expiration_date.present?
      membership_expired = DateTime.now.to_date > expiration_date
    end
    
    membership_expired
  end

  def latest_successful_invoice
    latest_successful_invoice = nil
    
    self.invoices.each do |invoice|
      next if !invoice.success || invoice.membership_expiration_date.blank?
      latest_successful_invoice = invoice
    end

    latest_successful_invoice    
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end
  
  
end
