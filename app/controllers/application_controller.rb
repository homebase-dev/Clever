class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  
  def create_new_total_test(user, pick_randomly)
      #puts "creating new total test!"

      test = Test.new
      
      test.user = user
      test.start = Time.now
      test.description = 'Gesamttest'
      
      if user && (user.member? || user.can_manage?)
        test = add_tests_to_total_test(test, pick_randomly)
      else
        test = add_tests_to_total_test_for_guest(test, pick_randomly)
      end
      
      test.save!
      test
  end
  
  def add_tests_to_total_test(test, pick_randomly) 
      # basiskenntnistest
      basic_test = Test.create(:description => "Basiskenntnistest", :available_time_sec => 60*60, :test_type => Test.test_types[:test])
      
      biology_test = create_bkt_test(3, 40, pick_randomly, 20*60, 'Biologie') 
      chemistry_test = create_bkt_test(11, 23, pick_randomly, 20*60, 'Chemie') 
      physics_test = create_bkt_test(2, 16, pick_randomly, 20*60, 'Physik') 
      math_test = create_bkt_test(1, 10, pick_randomly, 20*60, 'Mathematik') 

      basic_test.tests.push(biology_test, chemistry_test, physics_test, math_test)
      
      test.tests.push(basic_test)
      
      # textverständtnis
      textcomprehension_test = create_normal_test(10, 2, 10, pick_randomly, 60*60, 'Textverständnis') 
      test.tests.push(textcomprehension_test)
      
      # mittagspause
      pause_test = create_pause_test(15*60, 'Mittagspause') 
      test.tests.push(pause_test)
      
      # figuren zusammensetzten
      figure_test = create_normal_test(13, 1, 15, pick_randomly, 20*60, 'Figuren zusammensetzen') 
      test.tests.push(figure_test)
      
      # gedächtnis und merkfähigkeit (lernphase)
      memory_test_learningphase = create_learnphase_test(5, 1, 15, pick_randomly, 25*60, 'Gedächtnis und Merkfähigkeit Lernphase') 
      test.tests.push(memory_test_learningphase)
      
      # zahlenfolgen
      numbers_test = create_normal_test(6, 1, 15, pick_randomly, 15*60, 'Zahlenfolgen') 
      test.tests.push(numbers_test)
      
      # implikationen erkennen
      implications_test = create_normal_test(8, 1, 10, pick_randomly, 10*60, 'Implikationen') 
      test.tests.push(implications_test)
      
      # gedächtnis und merkfähigkeit (reproduktionsphase)
      memory_test_reproductionphase = create_reproductionphase_test(memory_test_learningphase, 8*60, 'Gedächtnis und Merkfähigkeit Reproduktionsphase') 
      test.tests.push(memory_test_reproductionphase)
      
      # wortflüssigkeit
      words_test = create_normal_test(7, 1, 15, pick_randomly, 20*60, 'Wortflüssigkeit') 
      test.tests.push(words_test)
      
      # soziales entscheiden
      social_test = create_normal_test(14, 1, 10, pick_randomly, 10*60, 'Soziales entscheiden') 
      test.tests.push(social_test)
      
      test
  end
  
  def add_tests_to_total_test_for_guest(test, pick_randomly)
      test.test_type = Test.test_types[:guest_test]
    
      # basiskenntnistest
      basic_test = Test.create(:description => "Basiskenntnistest", :available_time_sec => 60*60, :test_type => Test.test_types[:test])
      
      nb_of_contexts = 1
      nb_of_questions = 3
      
      biology_test = create_bkt_test(3, nb_of_questions, pick_randomly, 20*60, 'Biologie') 
      chemistry_test = create_bkt_test(11, nb_of_questions, pick_randomly, 20*60, 'Chemie') 
      physics_test = create_bkt_test(2, nb_of_questions, pick_randomly, 20*60, 'Physik') 
      math_test = create_bkt_test(1, nb_of_questions, pick_randomly, 20*60, 'Mathematik') 

      basic_test.tests.push(biology_test, chemistry_test, physics_test, math_test)
      
      test.tests.push(basic_test)
      
      # textverständtnis
      textcomprehension_test = create_normal_test(10, nb_of_contexts, nb_of_questions, pick_randomly, 60*60, 'Textverständnis') 
      test.tests.push(textcomprehension_test)
      
      # mittagspause
      pause_test = create_pause_test(15*60, 'Mittagspause') 
      test.tests.push(pause_test)
      
      # figuren zusammensetzten
      figure_test = create_normal_test(13, nb_of_contexts, nb_of_questions, pick_randomly, 20*60, 'Figuren zusammensetzen') 
      test.tests.push(figure_test)
      
      # gedächtnis und merkfähigkeit (lernphase)
      memory_test_learningphase = create_learnphase_test(5, nb_of_contexts, nb_of_questions, pick_randomly, 25*60, 'Gedächtnis und Merkfähigkeit Lernphase') 
      test.tests.push(memory_test_learningphase)
      
      # zahlenfolgen
      numbers_test = create_normal_test(6, nb_of_contexts, nb_of_questions, pick_randomly, 15*60, 'Zahlenfolgen') 
      test.tests.push(numbers_test)
      
      # implikationen erkennen
      implications_test = create_normal_test(8, nb_of_contexts, nb_of_questions, pick_randomly, 10*60, 'Implikationen') 
      test.tests.push(implications_test)
      
      # gedächtnis und merkfähigkeit (reproduktionsphase)
      memory_test_reproductionphase = create_reproductionphase_test(memory_test_learningphase, 8*60, 'Gedächtnis und Merkfähigkeit Reproduktionsphase') 
      test.tests.push(memory_test_reproductionphase)
      
      # wortflüssigkeit
      words_test = create_normal_test(7, nb_of_contexts, nb_of_questions, pick_randomly, 20*60, 'Wortflüssigkeit') 
      test.tests.push(words_test)
      
      # soziales entscheiden
      social_test = create_normal_test(14, nb_of_contexts, nb_of_questions, pick_randomly, 10*60, 'Soziales entscheiden') 
      test.tests.push(social_test)
      
      test
  end
  
  
  def create_new_total_test_for_guest(user)
      #puts "creating new total test for guests!"

      test = create_new_total_test(user, false)
      
      test.test_type = Test.test_types[:guest_test]
   
      test.save!
      test
  end
  
  
  def create_test(category_id, type, nb_of_contexts, nb_of_questions, pick_randomly, available_time_sec, description) 
    test = Test.new
    test.description = description
    test.available_time_sec = available_time_sec
    test.test_type = type
    
    category = Category.find_by_id(category_id)
    
    if category
      #puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      picked_questions = pick_questions(category, nb_of_contexts, nb_of_questions, pick_randomly)
      create_test_assignations(test, picked_questions)
    end

    test.save!
    test
  end
  
  
  def create_partial_test(user, category, nb_of_contexts, nb_of_questions, pick_randomly)
      #puts "**************** is partial test!".yellow.on_white
      
      test = Test.new

      #TODO check if nb_of_questions >0 && <= category.question.count
      
      test.user = user
      test.description = category.name
      test.start = Time.now
      
      nb_of_contexts = 1 if nb_of_contexts.blank?
      nb_of_questions = 3 if nb_of_contexts.blank?
      
      if category && category.question_contexts.empty?
        flash[:error] = "Die Kategorie #{category.name} hat leider noch keine Fragenkontexte, versuche es später nocheinmal."
        redirect_to(:back) and return
      end
      
      picked_questions = pick_questions(category, nb_of_contexts, nb_of_questions, pick_randomly) 
  
      #puts "RESULT QUESTIONS"
      #print_questions(picked_questions)
      
      test.save!
      
      create_test_assignations(test, picked_questions)
      
      test.save!
      test
  end
  
  def create_new_partial_test_for_guest(user, category)
      #puts "**************** is partial test!".yellow.on_white
      
      test = create_partial_test(user, category, 1, 3, false);
      
      test.test_type = Test.test_types[:guest_test]
      
      test.save!
      
      test
  end
  
  def create_test_assignations(test, questions)
    questions.each do |q|
      assignation = Assignation.new(:test => test, :question => q)
      assignation.save!
    end
  end
  
  
  
  def pick_questions(category, nb_of_contexts, nb_of_questions, pick_randomly)
    questions = []
    
    if !category
      logger.warn "pick_questions(...) category was empty!"
      return questions
    end
    
    if nb_of_contexts.blank? || nb_of_questions.blank?
      logger.warn "pick_questions(...) question_context or nb_of_questionswas was empty!"
      return questions
    end
    
    if category.question_contexts.count == 1
      only_context = category.question_contexts.first
      questions = pick_questions_from_question_context(only_context, nb_of_questions, pick_randomly)
    elsif category.question_contexts.count > 1
      contexts = pick_contexts_from_category(category, nb_of_contexts, pick_randomly)
      
      if contexts.empty?
        logger.warn "pick_questions(...) Category with id #{category.id} has only question_contexts which have no questions!"         
      end
      
      # TODO fix logic (when one empty context, skip)
      contexts.each do |context|
        questions.concat pick_questions_from_question_context(context, nb_of_questions, pick_randomly)
      end
      
    end
        
    questions
  end
  
  def pick_questions_from_question_context(question_context, nb_of_questions, pick_randomly) 
    questions = []
    i = 0
    
    if pick_randomly
      all_questions = question_context.questions.shuffle
    else
      all_questions = question_context.questions
    end
    
    while i < nb_of_questions do
      question = all_questions[i]
      
      i += 1
      
      if question.blank? || question.answers.empty?
        next
      end
      
      questions << question
    end
    
    questions
  end
  
  def pick_contexts_from_category(category, nb_of_contexts, pick_randomly) 
    contexts = []
    i = 0
    
    if pick_randomly
      all_contexts = category.question_contexts.shuffle
    else
      all_contexts = category.question_contexts
    end 
     
    while i < nb_of_contexts do
      context = all_contexts[i]

      i += 1
            
      if context.blank? || context.questions.empty?
        next
      end
      
      contexts << context
    end
    
    contexts
  end
  
  
  def print_questions(questions)
    questions.each do |q|
      puts q.id
    end
  end
  
  
  
  def create_bkt_test(category_id, nb_of_questions, pick_randomly, available_time_sec, description)
    test = create_test(category_id, Test.test_types[:part_of_bkt], 1, nb_of_questions, pick_randomly, available_time_sec, description) 
  end
  
  def create_normal_test(category_id, nb_of_contexts, nb_of_questions, pick_randomly, available_time_sec, description) 
    test = create_test(category_id, Test.test_types[:test], nb_of_contexts, nb_of_questions, pick_randomly, available_time_sec, description) 
  end
  
  def create_pause_test(available_time_sec, description) 
    test = create_test(nil, Test.test_types[:pause], nil, nil, false, available_time_sec, description) 
  end
  
  def create_learnphase_test(category_id, nb_of_contexts, nb_of_questions, pick_randomly, available_time_sec, description) 
    test = create_test(category_id, Test.test_types[:test_learnphase], nb_of_contexts, nb_of_questions, pick_randomly, available_time_sec, description) 
  end
  
  def create_reproductionphase_test(learnphase_test, available_time_sec, description) 
    test = create_test(nil, Test.test_types[:test_reproductionphase], nil, nil, false, available_time_sec, description) 
    
    learnphase_test.assignations.each do |a|
      test.assignations << a.dup
    end
    
    first_assignation = test.assignations.first
    
    learnphase_test.assignations.each do |a|
      learnphase_test.assignations.delete(a)
    end
    
    learnphase_test.assignations << first_assignation.dup 
    #make shallow copies of the learnphase_test associations
    #learnphase_test.assignations.each do |a|
    #  test.assignations << a.dup 
    #end
    
    #TODO put all assignations with different question_contexts into this
    #put only the first one
    #test.assignations << test.assignations.first if test.assignations and test.assignations.any?
    
    test.save!
    test
  end
    
    
  def show_context?(assignation, previous_assignation)
    show_context = false
    
    if assignation.test.test_reproductionphase?
      #puts "reproduction_phase -> don't show context".yellow.on_white
      return show_context
    end
    
    context_test_workflow = assignation.question.question_context.test_workflow
    
    if context_test_workflow.not_visible?
      return false
    elsif context_test_workflow.always_visible?
      return true
    end
    
    show_context = assignation.belongs_to_different_context?(previous_assignation) #have_different_contexts?(assignation, previous_assignation)
    show_context
  end
  
    
  def set_checked_answers(previous_assignation, checked_answers)
    if previous_assignation.present?
      #if there are any prevous checks, remove them, since now there are now ones
      previous_assignation.checks.destroy_all
      
      if checked_answers.present? and checked_answers.any?  
        checked_answers.each do |ca|
          checked_answer = Answer.find_by_id(ca)
          check = Check.new(:assignation => previous_assignation, :answer => checked_answer)
          begin
            check.save!
          rescue ActiveRecord::RecordInvalid => e
            logger.info "Check for this Answer already existing, not creating new one"
          end
        end
      end
      
    end
  end
    
  def set_test_start_to_now(test)
    if test.blank?
       Rails.logger.warn "WARNING: set_test_start_to_now(...) could not be set, because test is nil!"
      return
    end
    
    test.start = Time.now
    test.save!
    #puts "SET test.start test.id #{test.id} -> #{test.start}".yellow.on_black
  end
    
  def set_test_end_to_now(test)
    if test.blank?
      Rails.logger.warn "WARNING: set_test_end_to_now(...) could not be set, because test is nil!"
      return
    end
    test.end = Time.now
    test.save!
    #puts "SET test.end test.id #{test.id} -> #{test.end}".yellow.on_black
  end

  def calculate_elapsed_seconds(assignation)
    elapsed_seconds = 0
    now = Time.now
    
    if assignation.blank? || assignation.test.blank? || assignation.test.start.blank?
      Rails.logger.warn "WARNING: calculate_elapsed_seconds(...) assignation.test.start is nil (or one of its parts)!"
      test_start = now
    else
      test_start = assignation.test.start
    end
    
    elapsed_seconds = (now - test_start).to_i 
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
  
  
  def average_test_score(tests)
    average_test_score = 0
    
    return average_test_score if ( tests.nil? || tests.empty? )
    
    sum_scores = 0
    tests.each do |t|
      sum_scores += t.userscore_percent.to_f
    end
    
    if tests.any?
      average_test_score = sum_scores / tests.count
    end
      
    average_test_score
  end
  
end
