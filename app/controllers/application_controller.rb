class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def pick_random_questions(category, nb_of_contexts, nb_of_questions)
    random_questions = []
    
    # TODO fix, DRY
    if category.blank? #Mixed Category was choosen
      all_categories = Category.all.published
      
      all_categories.each do |c|
        if c.question_contexts.count == 1
          only_context = c.question_contexts.first
          random_questions.concat pick_random_questions_from_question_context(only_context, nb_of_questions)
        elsif c.question_contexts.count > 1
          random_contexts = pick_random_contexts_from_category(c, nb_of_contexts)
          
          random_contexts.each do |context|
            random_questions.concat pick_random_questions_from_question_context(context, nb_of_questions)
          end
          
        end
      end
      
      return random_questions
    end
    
    
    if category.question_contexts.count == 1
      only_context = category.question_contexts.first
      random_questions = pick_random_questions_from_question_context(only_context, nb_of_questions)
    elsif category.question_contexts.count > 1
      random_contexts = pick_random_contexts_from_category(category, nb_of_contexts)
      
      random_contexts.each do |context|
        random_questions.concat pick_random_questions_from_question_context(context, nb_of_questions)
      end
      
    end
        
    random_questions
  end
  
  
  def pick_random_contexts_from_category(category, nb_of_contexts) 
    random_contexts = []
    $i = 0
    all_contexts_mixed = category.question_contexts.shuffle
    
    while $i < nb_of_contexts do
      context = all_contexts_mixed[$i]
      
      if context.present?
        random_contexts << context
      else
        break
      end
      
      $i +=1
    end
    
    random_contexts
  end
  
  
  def pick_random_questions_from_question_context(question_context, nb_of_questions) 
    random_questions = []
    $i = 0
    
    all_questions_mixed = question_context.questions.shuffle
    
    while $i < nb_of_questions do
      question = all_questions_mixed[$i]
      
      if question.present?
        random_questions << question
      else
        break
      end
      
      $i +=1
    end
    
    random_questions
  end
  
  
  
  def random_string(size) 
    range = [*'A'..'Z']
    Array.new(size){ range.sample }.join
  end
  
  def random_test_id
    test_id = random_string(3) + "-" + random_string(3) + "-" + random_string(3) + "-" + random_string(3)
  end
  
  
  
  def create_invoice_pdf(user, date, invoice) 
    pdf = InvoicePdf.new(user, invoice)
    pdf_filename = "public/storage/invoices/#{date}uid#{user.id}iid#{invoice.id}.pdf"
    pdf.render_file pdf_filename
    pdf_filename
  end
  
  def send_invoice_email(user, pdf_filename)
    begin
      UserMailer.invoice_email(user, pdf_filename).deliver!
    rescue => ex
      logger.error ex.message
    end
  end
  
  
end
