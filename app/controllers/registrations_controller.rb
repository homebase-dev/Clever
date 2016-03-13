class RegistrationsController < Devise::RegistrationsController
 
 
  def after_sign_up_path_for(resource)
    static_pages_payment_path
  end 
  
  private
 
  def sign_up_params
    params.require(:user).permit(:firstname, :lastname, :phone, :birthdate, :street, :zip, :city, :country, :email, :password, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:firstname, :lastname, :phone, :birthdate, :street, :zip, :city, :country, :email, :password, :password_confirmation, :current_password)
  end
end