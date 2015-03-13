class QuestionContextsController < ApplicationController
  before_action :set_question_context, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @category = Category.find(params[:category_id])
    @quiz = @category.quiz
    @question_contexts = @category.question_contexts.order('id DESC').page(params[:page]).per(50)
    respond_with(@question_contexts)
  end

  def show
    respond_with(@question_context)
  end

  def new
    @category = Category.find(params[:category_id])
    @quiz = @category.quiz
    @question_context = QuestionContext.new
    @question_context.published = true
    
    #5.times { @question.answers.build }  

    respond_with(@quiz, @category, @question_context)
  end

  def edit
  end

  def create
    @category = Category.find(params[:category_id])
    @question_context = QuestionContext.new(question_context_params)
    @question_context.category = @category
    @question_context.creator_id = current_user.id
    @question_context.save
    
    respond_with(@question_context)
  end

  def update
    @question_context.update(question_context_params)
    respond_with(@question_context)
  end

  def destroy
    @category = @question_context.category
    @quiz = @category.quiz
    @question_context.destroy
    respond_with(@quiz, @category, @question_context)
  end

  private
    def set_question_context
      @question_context = QuestionContext.find(params[:id])
    end

    def question_context_params
      params.require(:question_context).permit(:content, :display_time_minutes, :test_workflow_id, :category_id, :creator_id, :published)
    end
end
