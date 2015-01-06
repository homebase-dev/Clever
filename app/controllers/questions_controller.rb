class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @category = Category.find(params[:category_id])
    @category_questions = @category.questions.order('id DESC').page(params[:page]).per(50)
    
    respond_with(@category_questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @category = Category.find(params[:category_id])
    @quiz = @category.quiz
    @question = Question.new
    @question.published = true
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
    
    create_answer_on_the_fly(params[:answer1_text], params[:answer1_correct], @question)
    create_answer_on_the_fly(params[:answer2_text], params[:answer2_correct], @question)
    create_answer_on_the_fly(params[:answer3_text], params[:answer3_correct], @question)
    create_answer_on_the_fly(params[:answer4_text], params[:answer4_correct], @question)
    create_answer_on_the_fly(params[:answer5_text], params[:answer5_correct], @question)
    
    respond_with(@question)
  end
  
  def create_answer_on_the_fly(text, correct, question)
    if text.present?
      answer = Answer.new(:text => text)
      answer.published = true
      answer.correct = true if (correct.present? && correct)
      answer.question = question
      answer.save!
    end
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
      params.require(:question).permit(:text, :category_id, :creator_id, :published, :solution)
    end
end
