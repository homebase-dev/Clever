# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html
  
  
  def index
    @users = User.all.order('id DESC').page(params[:page]).per(50)
    respond_with(@users)
  end
  

  def update
    @user = current_user
    
    if @user.update(user_params)
      flash[:notice] = "Änderungen erfolgreich durchgeführt"
    else
      flash[:error] = "Beim Ändern trat ein Fehler auf."
    end
    
    redirect_to static_pages_profile_data_path
  end
  
  
  
  #TODO add authentication
  def edit_admin
    if !current_user.admin?
      flash[:error] = "Du bist nicht berechtigt diese Operation auszuführen."
      redirect_to static_pages_home_path and return
    end
    
    @user = User.find_by_id(params[:id])
  end
  
  #TODO put authentication outside
  def update_admin
    if !current_user.admin?
      flash[:error] = "Du bist nicht berechtigt diese Operation auszuführen."
      redirect_to users_index_path and return
    end
    
    @user = User.find_by_email(user_params[:email])
    role_id = params[:user][:role]
    role = Role.find_by_id(role_id)
    
    if @user.update(user_params)
      if role.present?
        @user.role = role
        @user.save!
        flash[:notice] = "Der Benutzer hat jetzt die Rolle: "+role.name+"."
      end
      flash[:notice] = "Änderungen erfolgreich durchgeführt."
    else
      flash[:error] = "Beim Ändern trat ein Fehler auf."
    end
    
    redirect_to users_index_path
  end
  
  
  
  
  
  
  def edit_email
    @user = current_user
  end

  def update_email
    @user = current_user
    
    #puts params.inspect
    
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
    params.required(:user).permit(:password, :password_confirmation, :email, :firstname, :lastname, :phone, :birthdate, :street, :zip, :city, :country)
  end
  
end
