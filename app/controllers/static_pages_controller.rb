# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  layout "application"
  
  before_action :authenticate_user!, only: [:profile_status, :profile_data]
  
  def home
  end

  def faq
    @all_published_faqs = (Faq.all.published.order('created_at DESC'))
    @top_faq = @all_published_faqs.first
    @older_faqs = @all_published_faqs.drop(1)
  end

  def about
  end

  def contact
  end

  def news
    @all_novelties_faqs = (Novelty.all.published.order('created_at DESC'))
    @top_novelty = @all_novelties_faqs.first
    @older_novelties = @all_novelties_faqs.drop(1)
  end

  def quiz
  end
  
  def profile_status
    @user = current_user
  end
  
  def profile_data
    @user = current_user
  end
  
  def admin
   
  end
  
  
  def payment
    @user = current_user
  end
  
  def pay
    @creditcard_number = params[:creditcard_number]
    @creditcard_expiration_date  = params[:creditcard_expiration_date]
    @creditcard_cnc = params[:creditcard_cnc]
    
    #TODO do payment processing
    
    payment_successful = true
    if payment_successful
      flash[:notice] = 'Die Bezahlung wurde erfolgreich abgeschlossen. Sie können jetzt unser volles Angebot nutzen!'
      current_user.role = Role.find_by_name('member')
      #TODO set membership_expiration_date
      current_user.save!
    else
      flash[:error] = 'Bei der Bezahlung trat ein Fehler auf, versuchen Sie es später nocheinmal.'
    end
    
    redirect_to static_pages_profile_status_path
  end
  
  def quiz_inspect
    @quiz = Quiz.find(params[:id])
  end
  
  def quiz_categories
    @quiz = Quiz.find(params[:id])
  end
  
  def category_overview
    @category = Category.find(params[:id])
  end
  
end
