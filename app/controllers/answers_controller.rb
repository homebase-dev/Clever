class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @question = Question.find(params[:question_id])
    @question_answers = @question.answers    
    
    respond_with(@question_answers)
  end

  def show
    respond_with(@answer)
  end

  def new
    @question = Question.find(params[:question_id])
    @category = @question.category
    @quiz = @category.quiz
    @answer = Answer.new
    @answer.published = true
    respond_with(@quiz, @category, @question, @answer)
  end

  def edit
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.creator_id = current_user.id
    @answer.save
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    @question = @answer.question
    @category = @question.category
    @quiz = @category.quiz
    @answer.destroy
    respond_with(@quiz, @category, @question, @answer)
  end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:text, :correct, :question_id, :creator_id, :published)
    end
end
