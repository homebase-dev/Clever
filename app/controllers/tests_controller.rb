class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tests = Test.all
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
    @test = Test.new(test_params)
    
    @test.testee = current_user
    @test.start = Time.now
    
    puts "PARAMS"
    puts params.inspect
    puts "CATEGORY_ID"
    puts params[:category_id]
    
    category = Category.find_by_id(params[:category_id])
    puts "CATEGORY"
    puts category.inspect
    
    $i = 0
    random_questions = []
    while $i < 10 do
      all_questions = category.questions
      #puts "ALL QUESTIONS"
      #puts all_questions.inspect
      
      #question = all_questions.shift
      question = all_questions[$i]
      
      if question.present?
        random_questions << question
      end
      
      puts("Inside the loop i = #$i" )
      $i +=1
    end
    
    puts "ALL THE RANDOM QUESTIONS"
    puts random_questions.inspect
    
    
    
    @test.save
    
    random_questions.each do |q|
      assignation = Assignation.new(:test => @test, :question => q)
      assignation.save!
    end
 
    
    respond_with(@test)
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
    
  end
  
  def take
    @test = Test.find_by_id(params[:id])
    @question_number = params[:question_number].to_i - 1
    @question =  @test.questions[@question_number]
    @cheat = params[:cheat] 
    
    if @question_number == @test.questions.count
      redirect_to test_result_path(:id => @test.id) and return
    end
    
    respond_with(@question)
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
