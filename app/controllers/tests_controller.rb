class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  respond_to :html

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
    
    @nb_of_questions = params[:nb_of_questions].to_i
    
    #TODO check if nb_of_questions >0 && <= category.question.count
    
    @test.testee = current_user
    @test.start = Time.now
    
    puts "PARAMS"
    puts params.inspect
    puts "CATEGORY_ID"
    puts params[:category_id]
    
    category = Category.find_by_id(params[:category_id])
    puts "CATEGORY"
    puts category.inspect
    
    if category.questions.empty?
      flash[:error] = "Die Kategorie "+category.name+" hat leider noch keine Fragen, versuche es später nocheinmal."
      redirect_to(:back) and return
    end
    
    random_questions = pick_random_questions(category)
    puts "RESULT QUESTIONS"
    print_questions(random_questions)
    
    @test.save!
    
    create_test_assignations(random_questions)
 
    redirect_to test_step_path(:id => @test.id, :assignation_number => 1) and return
    #respond_with(@test)
  end
  
  def pick_random_questions(category)
    random_questions = []
    $i = 0
    all_questions_mixed = category.questions.shuffle
    while $i < @nb_of_questions do
      #question = all_questions.shift
      question = all_questions_mixed[$i]
      
      if question.present?
        random_questions << question
      else
        break
      end
      
      #puts("Inside the loop i = #$i" )
      $i +=1
    end
    
    random_questions
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

  def new_test_from_category
    @test = Test.new
    respond_with(@test)
  end
  
  def step
    @test = Test.find_by_id(params[:id])
    @assignation_number = params[:assignation_number].to_i - 1
    @checked_answers = params[:ca]
    
    @assignation =  @test.assignations[@assignation_number]#@test.questions[@question_number]
    @previous_assignation =  @test.assignations[@assignation_number-1]
    
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
      
    
    if @assignation_number == @test.questions.count
      redirect_to test_result_path(:id => @test.id) and return
    end
    
    respond_with(@question)
  end
  
  
  def post_answer
    
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
