# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  layout "application"
  
  before_action :authenticate_user!, only: [:profile_status, :profile_data]
  
  def home
    @novelties = (Novelty.all.published.order('created_at DESC'))
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
    @client_token = Braintree::ClientToken.generate
  end
  
  def pay
    @user = current_user
    #@creditcard_number = params[:creditcard_number]
    #@creditcard_expiration_date  = params[:creditcard_expiration_date]
    #@creditcard_cnc = params[:creditcard_cnc]
    
    #TODO do payment processing
    nonce = params[:payment_method_nonce]
    
    render action: static_pages_profile_status_path and return unless nonce
    
    #TODO create order instance
              
    result = Braintree::Transaction.sale(
      :amount => "29.90",
      :payment_method_nonce => nonce,   
      :custom_fields => {
        :clever_user_id => @user.id
      },   
      #:order_id => "order id",
      #:merchant_account_id => "my id",
      :customer => {
        :first_name => @user.firstname,
        :last_name => @user.lastname,
        #:phone => "312-555-1234",
        :email => @user.email
      },
      #:billing => {
      #  :first_name => @user.firstname,
      #  :last_name =>  @user.lastname,
      #  #:street_address => "1 E Main St",
      #  #:extended_address => "Suite 403",
      #  #:locality => "Chicago",
      #  #:region => "IL",
      #  #:postal_code => "60622",
      #  #:country_code_alpha2 => "US"
      #},
      :options => {
        :submit_for_settlement => true
      },
      :channel => "CleverLearningQuiz"
    )
    
    if result.success?
      if current_user.role == Role.find_by_name('registered')
        current_user.role = Role.find_by_name('member')
        current_user.save!
      end
      #TODO set success in order instance
      flash[:notice] = "Die Bezahlung wurde erfolgreich abgeschlossen. Sie können jetzt unser volles Angebot nutzen!" 
    else
      #TODO set fail in order instance
      flash[:alert] = "Bei der Bezahlung trat ein Fehler auf, versuchen Sie es später nocheinmal. #{result.transaction.processor_response_text}"
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
  
  def quiz_readme
    
  end
  
end
