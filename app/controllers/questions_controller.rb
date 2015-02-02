class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @category = Category.find(params[:category_id])
    @question_context = QuestionContext.find(params[:question_context_id])
    @category_questions = @question_context.questions.order('id DESC').page(params[:page]).per(50)
    
    respond_with(@category_questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @category = Category.find(params[:category_id])
    @question_context = QuestionContext.find(params[:question_context_id])
    @quiz = @category.quiz
    @question = Question.new
    @question.published = true
    
    5.times { @question.answers.build }  

    respond_with(@quiz, @category, @question)
  end

  def edit
    #@question = Question.find(params[:id])
  end

  def create
    #@category = Category.find(params[:category_id])
    @question_context = QuestionContext.find(params[:question_context_id])
    @question = Question.new(question_params)
    #@question.category = @question_context.category
    @question.question_context = @question_context
    @question.creator_id = current_user.id
    @question.save
    
    respond_with(@question)
  end
  

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question_context = @question.question_context
    @category = @question_context.category
    @quiz = @category.quiz
    @question.destroy
    respond_with(@quiz, @category, @question_context, @question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:text, :category_id, :creator_id, :published, :solution, answers_attributes: [:id, :text, :correct, :_destroy, :creator_id, :published])
    end
end
