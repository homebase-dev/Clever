# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  layout "application"
  
  layout "application_no_navbar", only: [:print_category, :print_random_test]
  
  before_action :authenticate_user!, only: [:profile_status, :profile_data]
  
  def home
    @next_med_exam_date = Settings.next_med_exam_date
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
    @quizzes = Quiz.all.published
    
    if @quizzes.size == 1
      redirect_to static_pages_quiz_categories_path(:id => @quizzes.first.id)
    end
    
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
    membership_price = Settings[:membership_price_euro]
    result = Braintree::Transaction.sale(
      :amount => membership_price,
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
      
      #TODO create pdf bill
      #TODO send mail 
      #UserMailer.bill_email(current_user).deliver!
      
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
  
  def print_category
    @category = Category.find(params[:id])
    @show_solutions = params[:show_solutions]
    @hide_footer = true;
  end
  
  def print_random_test
    #@show_solution = "true"
    
    @test_id = random_test_id()
    
    @zahlenfolgen_questions = pick_random_questions_from_question_context(Category.find_by_id(6).question_contexts.first, 15)
    
    @gedaechtnis_context = Category.find_by_id(5).question_contexts.shuffle.first
    @gedaechtnis_questions = pick_random_questions_from_question_context(@gedaechtnis_context, 25)
    
    @figuren_questions = pick_random_questions_from_question_context(Category.find_by_id(13).question_contexts.second, 15) #TODO server side broken
    @wortfluessigkeit_questions = pick_random_questions_from_question_context(Category.find_by_id(7).question_contexts.first, 15)
    @implikationen_questions = pick_random_questions_from_question_context(Category.find_by_id(8).question_contexts.first, 10)
    
    @soziales_context = Category.find_by_id(14).question_contexts.first
    ten_percent_question_count = (@soziales_context.questions.count * 0.1).round
    @soziales_questions = pick_random_questions_from_question_context(Category.find_by_id(14).question_contexts.first, ten_percent_question_count)
    
    @biologie_questions = pick_random_questions_from_question_context(Category.find_by_id(3).question_contexts.first, 40)
    @chemie_questions = pick_random_questions_from_question_context(Category.find_by_id(11).question_contexts.first, 24)
    @physik_questions = pick_random_questions_from_question_context(Category.find_by_id(2).question_contexts.first, 16)
    @mathematik_questions = pick_random_questions_from_question_context(Category.find_by_id(1).question_contexts.first, 10)
    
    #@textverstaendtnis_contexts = Category.find_by_id(10).question_contexts.shuffle.take(10)
    
    @textverstaendtnis_big_context_questions = nil
    @textverstaendtnis_small_context1_questions = nil
    @textverstaendtnis_small_context2_questions = nil
    @textverstaendtnis_small_context3_questions = nil
    @textverstaendtnis_small_context4_questions = nil
    
    small_texts_added = 0
    big_texts_added = 0
    #@textverstaendtnis_contexts = []
    Category.find_by_id(10).question_contexts.shuffle.each do |context|
      if context.content.split.size >= 300 
        if big_texts_added < 1
          #@textverstaendtnis_contexts << context
          @textverstaendtnis_big_context_questions = context.questions.shuffle.take(6)
          big_texts_added += 1   
        end          
      else
        if small_texts_added < 4
          if small_texts_added == 0
            @textverstaendtnis_small_context1_questions = context.questions.shuffle.take(1)
          elsif small_texts_added == 1
            @textverstaendtnis_small_context2_questions = context.questions.shuffle.take(1)
          elsif small_texts_added == 2
            @textverstaendtnis_small_context3_questions = context.questions.shuffle.take(1)
          elsif small_texts_added == 3
            @textverstaendtnis_small_context4_questions = context.questions.shuffle.take(1)
          end
          #@textverstaendtnis_contexts << context
          small_texts_added += 1
        end
      end
    end

    @show_solutions = params[:show_solutions]
    @hide_footer = true;
  end
  
  
  def quiz_readme
    
  end
  
  
  
  def invoice_pdf

    #respond_with(@quiz)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(current_user)
        send_data pdf.render, :filename => "invoice_user_#{current_user.id}.pdf",
                              :type => "application/pdf",
                              :disposition => "inline"
      end
    end
  end
  
  
  
end
