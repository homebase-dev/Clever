class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @category = Category.find(params[:category_id])
    @category_questions = @category.questions
    
    respond_with(@category_questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @category = Category.find(params[:category_id])
    @quiz = @category.quiz
    @question = Question.new
    respond_with(@quiz, @category, @question)
  end

  def edit
    #@question = Question.find(params[:id])
  end

  def create
    @category = Category.find(params[:category_id])
    @question = Question.new(question_params)
    @question.category = @category
    @question.creator_id = current_user.id
    @question.save
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @category = @question.category
    @quiz = @category.quiz
    @question.destroy
    respond_with(@quiz, @category, @question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:text, :category_id, :creator_id, :published)
    end
end
