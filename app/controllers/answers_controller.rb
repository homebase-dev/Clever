class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @question = Question.find(params[:question_id])
    @question_answers = @question.answers.order('id DESC').page(params[:page]).per(20)
    
    respond_with(@question_answers)
  end

  def show
    respond_with(@answer)
  end

  def new
    @question = Question.find(params[:question_id])
    @question_context = @question.question_context
    @category = @question_context.category
    @quiz = @category.quiz
    @answer = Answer.new
    @answer.published = true
    respond_with(@quiz, @category, @question_context, @question, @answer)
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
    @question_context = @question.question_context
    @category = @question_context.category
    @quiz = @category.quiz
    @answer.destroy
    respond_with(@quiz, @category, @question_context, @question, @answer)
  end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:text, :correct, :question_id, :creator_id, :published)
    end
end
