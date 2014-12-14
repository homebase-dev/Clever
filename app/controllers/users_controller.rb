class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html
  
  def index
    @users = User.all
    respond_with(@users)
  end
  

  def update
    
  end
  
  
  

  def edit
    @user = current_user
  end
  
  def edit_email
    @user = current_user
  end

  def update_email
    @user = current_user
    
    puts params.inspect
    
    email_confirmation = params[:email_confirmation] 
    email = user_params[:email]
    
    if(email != email_confirmation) 
      flash.now[:error] = "Die E-mail Adressen stimmen nicht überein."
      render "edit_email" and return
    end
    
    if @user.update(user_params)
      flash[:notice] = "E-mail wurde erfolgreich geändert."
    else
      flash[:error] = "Beim Ändern trat ein Fehler auf."
    end
    
    redirect_to static_pages_profile_data_path
  end



  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      flash[:notice] = "Password wurde erfolgreich geändert."
    end
    
    redirect_to static_pages_profile_data_path
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:password, :password_confirmation, :email)
  end
  
end
