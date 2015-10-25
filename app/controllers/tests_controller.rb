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
    @test = Test.new
        
    if params[:test].present?
      @test = Test.new(test_params)
    end
    
    @nb_of_contexts = 1 
    @nb_of_questions = 3
    
    if current_user && (current_user.member? || current_user.can_manage?)
      @nb_of_contexts = params[:nb_of_contexts].to_i
      @nb_of_questions = params[:nb_of_questions].to_i
    end
    
    
    #TODO check if nb_of_questions >0 && <= category.question.count
    
    @test.testee = current_user
    @test.start = Time.now
    
    puts "PARAMS"
    puts params.inspect
    puts "CATEGORY_ID"
    puts params[:category_id]
    
    category = Category.find_by_id(params[:category_id])
    
        
    if category && category.question_contexts.empty?
      flash[:error] = "Die Kategorie "+category.name+" hat leider noch keine Fragenkontexte, versuche es später nocheinmal."
      redirect_to(:back) and return
    end
    
    random_questions = pick_random_questions(category, @nb_of_contexts, @nb_of_questions) 
    

    #random_questions = pick_random_questions(category)
    puts "RESULT QUESTIONS"
    print_questions(random_questions)
    
    #TODO uncomment
    @test.save!
    
    create_test_assignations(random_questions)
 
    redirect_to test_start_path(:id => @test.id)
    #redirect_to test_step_path(:id => @test.id, :assignation_number => 1) and return
  end
  
    
  def create_test_assignations(questions)
    questions.each do |q|
      assignation = Assignation.new(:test => @test, :question => q)
      assignation.save!
    end
  end
  
  def print_questions(questions)
    questions.each do |q|
      puts q.id
    end
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

  def start
    @test = Test.find_by_id(params[:id])
    @assignation_number = 0
    @assignation =  @test.assignations[@assignation_number]
    
    if @assignation.nil?
      logger.info "There are no assignations within the thest, probably the category has no context or questions"
      flash[:error] = "Die gewählte Kategorie hat leider noch keine Fragen, versuche es später nocheinmal."
      redirect_to static_pages_quiz_path and return
    end
    
    @question = @assignation.try(:question)
  end

  def new_test_from_category
    @test = Test.new
    respond_with(@test)
  end
  
  def step
    @test = Test.find_by_id(params[:id])
    @assignation_number = params[:assignation_number].to_i - 1
    @checked_answers = params[:ca]
    
    @assignation =  @test.assignations[@assignation_number]#@test.questions[@question_number]
    if @assignation_number-1 >= 0
      @previous_assignation = @test.assignations[@assignation_number-1]
    else 
      @previous_assignation = nil
    end
    
    @question = @assignation.try(:question)
    
    if @previous_assignation.present?
      #if there are any prevous checks, remove them, since now there are now ones
      @previous_assignation.checks.destroy_all
      
      if @checked_answers.present? and @checked_answers.any?  
        @checked_answers.each do |ca|
          checked_answer = Answer.find_by_id(ca)
          check = Check.new(:assignation => @previous_assignation, :answer => checked_answer)
          begin
            check.save!
          rescue ActiveRecord::RecordInvalid => e
            logger.info "Check for this Answer already existing, not creating new one"
          end
        end
      end
      
    end
    
    @timer_elapsed_seconds = (Time.now - @test.start).to_i
    
    
    if no_more_steps?(@assignation, @assignation_number, @test.questions.count)
      redirect_to test_result_path(:id => @test.id) and return
    end

    @workflow = @assignation.question.question_context.test_workflow
    @did_context_change = did_context_change?(@assignation, @previous_assignation)
    @show_context = show_context?(@assignation, @previous_assignation)
        
    respond_with(@question)
  end
  
  def no_more_steps?(assignation, assignation_number, test_questions_count)
    no_more_steps = assignation.nil? || assignation_number == test_questions_count
  end
  
  def post_answer
    
  end
  
  def did_context_change?(assignation, previous_assignation)
    did_context_changed = true 

    if previous_assignation.present?
      did_context_changed = false if assignation.question.question_context == previous_assignation.question.question_context
    end
    
    did_context_changed
  end
  
  def show_context?(assignation, previous_assignation)
    show_context = false
    context_test_workflow = assignation.question.question_context.test_workflow
    
    if context_test_workflow.not_visible?
      return false
    elsif context_test_workflow.always_visible?
      return true
    end
    
    show_context = did_context_change?(assignation, previous_assignation)
    show_context
  end
  
  
  def result
    @test = Test.find_by_id(params[:id])
    @question = @test.questions[0]
    @test.end = Time.now
    @test.save!
    
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
