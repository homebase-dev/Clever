class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  respond_to :html

  layout "application_no_navbar", only: [:step, :result]

  def index
    @tests = Test.all.order('id DESC').page(params[:page]).per(50)
    respond_with(@tests)
  end

  def show
    respond_with(@test)
  end

  def new
    @test = Test.new
    respond_with(@test)
  end

  def edit
  end
  
  def create
    puts "create test".yellow.on_white
    is_paying_member = current_user && (current_user.member? || current_user.can_manage?)
    do_total_test = (params[:total_test] == "true")
    nb_of_contexts = params[:nb_of_contexts]
    nb_of_questions = params[:nb_of_questions]
    
    if params[:test].present?
      @test = Test.new(test_params)
    end
    
    if do_total_test
      if is_paying_member
        @test = create_new_total_test(current_user, true)
      else
        @test = create_new_total_test_for_guest()
      end
    else
      category_id = params[:category_id]
      category = Category.find_by_id(category_id)
      
      if category.nil?
        flash[:error] = "Die gewählte Kategorie existiert nicht!"
        redirect_to static_pages_quiz_path and return
      end
      
      if is_paying_member
        @test = create_partial_test(current_user, category, nb_of_contexts, nb_of_questions, true)
      else
        @test = create_new_partial_test_for_guest(category)
      end
    end
    
    if @test.nil?
      flash[:error] = "Bei der Erstellung des Tests ist ein Fehler aufgetreten. Versuche es später erneut oder kontaktiere uns!"
      redirect_to static_pages_quiz_path and return
    end
    
    redirect_to test_start_path(:id => @test.id, :assignation_number => 1)
  end
  


  def update
    @test.update(test_params)
    respond_with(@test)
  end

  def destroy
    @test.destroy
    respond_with(@test)
  end
  
  
  # ---------------- Perform a test actions  --------------------

  def step
    @test = Test.find_by_id(params[:id])
    @assignation_number = params[:assignation_number].to_i
    @assignation_number = 1 if (@assignation_number.blank? || @assignation_number < 1)
    #@do_check_answers = (params[:do_check_answers] == "true")
    puts "STEP test: #{@test.id}, assignation_number: #{@assignation_number}".red.on_white
        
        
    puts ">>> assignations --------".yellow.on_white
    @assignation_index = @assignation_number - 1
    next_assignation_index = @assignation_index+1
    previous_assignation_index = @assignation_index-1
    
    @assignation = @test.assignation(@assignation_index)
    puts "  assignation (index: #{@assignation_index}): #{@assignation.inspect}".yellow.on_white
    
    @previous_assignation = @test.assignation(previous_assignation_index)
    puts "  previous_assignation (index: #{previous_assignation_index}): #{@previous_assignation.inspect}".yellow.on_white
    
    next_assignation = @test.assignation(next_assignation_index)
    puts "  next_assignation (index: #{next_assignation_index}): #{next_assignation.inspect}".yellow.on_white

    puts "-------------------------".yellow.on_white
    
    
    @checked_answers = params[:ca]
    @timer_elapsed_seconds = calculate_elapsed_seconds(@assignation)
    @previous_test = @test.previous_leaf_from_assignation(@test, @assignation)
    
    puts ">>> special flags ----------".yellow.on_white
    @skip_test_intro = (params[:skip_test_intro] == "true")
    @skip_pause = (params[:skip_pause] == "true")
    @skip_learning_phase = (params[:skip_learning_phase] == "true")
    puts "  skip_test_intro: #{@skip_test_intro}".yellow.on_white
    puts "  skip_pause #{@skip_pause}".yellow.on_white
    puts "  skip_learning_phase #{@skip_learning_phase}".yellow.on_white
    puts "---------------------------".yellow.on_white
    
    #puts "TEST start: #{@test.start}".yellow.on_white

    #puts "ELAPSED SECS: #{Time.now} - #{} #{@timer_elapsed_seconds}".yellow.on_white
    
    
    puts ">>> check no_more_steps ---------------".green.on_white
    #puts "no_more_steps?: #{@assignation.inspect}, #{@assignation_number}, #{@test.questions.count}".yellow.on_white
    no_more_steps = @assignation.nil? #no_more_steps?(@assignation) #, @assignation_number, @test.questions.count)
    puts "  no_more_steps: #{no_more_steps}".yellow.on_white
    if no_more_steps
      puts "  do_check_answers: #{@do_check_answers}".blue.on_black
      set_checked_answers(@previous_assignation, @checked_answers)
      
      puts "  goto result".blue.on_black
      redirect_to test_result_path(:id => @test.id, :last_assignation_number => @assignation_number-1) and return
    end
    puts "---------------------------------------".yellow.on_white
    
    
    @workflow = @assignation.question.question_context.test_workflow
    @did_context_change = @assignation.belongs_to_different_context?(@previous_assignation) #have_different_contexts?(@assignation, @previous_assignation)
    @show_context = show_context?(@assignation, @previous_assignation)

    
    
    #TODO move below no_more_steps?
    @test_changed = @assignation.belongs_to_different_test?(@previous_assignation)
    puts "  test_changed: #{@test_changed}".yellow.on_white

    puts ">>> check time_for_a_break -----------".green.on_white
    puts "  previous_test.pause? #{@previous_test.pause?}" if @previous_test
    #puts "assignation.test: #{@assignation.test.inspect}".yellow.on_white
    @time_for_a_break = @test_changed && @previous_test.present? && @previous_test.pause? && !@skip_pause && !@skip_test_intro
    puts "  time_for_a_break: #{@time_for_a_break}".yellow.on_white
    if @time_for_a_break
      puts "  do_check_answers: #{@do_check_answers}".blue.on_black
      set_checked_answers(@previous_assignation, @checked_answers)
      
      puts "  goto break".blue.on_black
      redirect_to test_pause_path(:id => @test.id, :assignation_number => @assignation_number, :pause_test_id => @previous_test.id) and return
    end  
    puts "--------------------------------------".yellow.on_white
    
    
    puts ">>> check test_learnphase ----------------------".green.on_white
    #TODO einen schritt zurückversetzten???
    @test_learnphase = @assignation.test.test_learnphase? && !@skip_learning_phase
    puts "  learning_phase: #{@test_learnphase}".yellow.on_white
    puts "  learning_phase".blue.on_black if @test_learnphase
    puts "  next_assignation_number: #{@assignation_number+1}".yellow.on_white if @test_learnphase
    puts "------------------------------------------------".yellow.on_white
    
    puts ">>> check test_reproductionphase ----------------------".green.on_white
    #TODO einen schritt zurückversetzten???
    @test_reproductionphase = @assignation.test.test_reproductionphase?
    puts "  test_reproductionphase: #{@test_reproductionphase}".yellow.on_white
    puts "  test_reproductionphase".blue.on_black if @test_reproductionphase
    puts "------------------------------------------------".yellow.on_white
    

    
    puts ">>> check show_test_intro ----------------------------".green.on_white
    show_test_intro = @test_changed && !@skip_test_intro
    puts "  show_test_intro(test_changed: #{@test_changed}, skip_test_intro: #{@skip_test_intro}): #{show_test_intro}".yellow.on_white
    if show_test_intro
      if !@skip_pause
        puts "  do_check_answers: #{@do_check_answers}".blue.on_black
        set_checked_answers(@previous_assignation, @checked_answers)
      end
      puts "  goto show_test_intro (same assignation)".blue.on_black
      set_test_end_to_now(@previous_assignation.test) if @previous_assignation
      redirect_to test_start_path(:id => @test.id, :assignation_number => @assignation_number) and return
    end  
    
    do_set_checked_answers = !@skip_test_intro #no checking after an intro
    @question = @assignation.try(:question)
    if do_set_checked_answers
      puts ">>> do check answers -------------".yellow.on_white
      puts "  do_check_answers: #{@do_check_answers}".blue.on_black
      set_checked_answers(@previous_assignation, @checked_answers)
      puts "----------------------------------".yellow.on_white
    end    
    
    puts ">>> goto next Step -----------------------------------".blue.on_black
    
    respond_with(@question)
  end
  
  
  def start
    @test = Test.find_by_id(params[:id])
    
    @assignation_number = params[:assignation_number].to_i
    
    @assignation_index = @assignation_number-1
    
    set_test_start_to_now(@test) if (@assignation_number == 1) #set global test.start
    
    puts "START: test: #{@test.id}, assignation_number: #{@assignation_number}".red.on_white
    
    @assignation = @test.assignation(@assignation_index) #was 0
    puts "assignation: #{@assignation.inspect}".yellow.on_white
    
    if @assignation.nil?
      logger.info "Test could not be started. There are no assignations within the test, probably the category has no context or questions"
      flash[:error] = "Der Test konnte nicht gestartet werden, die gewählte Kategorie hat leider noch keine Fragen. Versuche es später nocheinmal."
      redirect_to static_pages_quiz_path and return
    end
    
    set_test_start_to_now(@assignation.test) #set local test.start

    @question = @assignation.try(:question)
  end
  
  def pause
    @test = Test.find_by_id(params[:id])
    @pause_test = Test.find_by_id(params[:pause_test_id])
    puts "@pause_test: #{@pause_test.inspect}".red.on_white
    @assignation_number = params[:assignation_number].to_i 
    @pause_finished_date = @pause_test.available_time_sec.seconds.from_now.in_time_zone('Vienna').strftime("%Y/%m/%d %H:%M:%S")
    puts "pause duration: #{@pause_finished_date}, #{@pause_test.available_time_sec.seconds.from_now}".red.on_white
    @pause_minutes = (@pause_test.available_time_sec / 60).to_i
  end

  
  def result
    @test = Test.find_by_id(params[:id])
    #@question = @test.questions[0]
    @question = @test.assignation(0).question
    #@test.end = Time.now
    #@test.save!
    
    @last_assignation_number = params[:last_assignation_number].to_i
    puts "RESULT test: #{@test.id}, last_assignation_number: #{@last_assignation_number}".red.on_white
    
    last_assignation_index = @last_assignation_number - 1
    
    #a = @test.assignation(59)
    #puts "#{a.id} -> #{a.passed?}".yellow.on_black
    @assignations = @test.assignation_array()
    assignations_hash = {:assignations => @assignations}
    
    @score = @test.score(assignations_hash)
    @max_score = @test.max_score(assignations_hash)
    @score_in_percent = @test.score_in_percent(assignations_hash)
    #@passed_assignation_count = @test.passed_assignation_count(assignations_hash)
    #puts "Passed assignations: #{@passed_assignation_count}".yellow.on_red
    #@result_in_percent = @test.result_in_percent(assignations_hash)
    
    local_test = @test.assignation(last_assignation_index).test
    
    set_test_end_to_now(@test) #global test.end
    set_test_end_to_now(local_test) #local test.end
    
    respond_with(@test)
  end
  
  
  

  private
    def set_test
      @test = Test.find(params[:id])
    end

    def test_params
      params.require(:test).permit(:testee_id, :start, :end)
    end

end
