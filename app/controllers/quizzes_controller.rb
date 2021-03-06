class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @quizzes = Quiz.all.order('id DESC').page(params[:page]).per(20)
    respond_with(@quizzes)
  end

  def show
    #respond_with(@quiz)
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = QuizPdf.new(@quiz)
        send_data pdf.render, :filename => "quiz_#{@quiz.id}.pdf",
                              :type => "application/pdf",
                              :disposition => "inline"
      end
    end
    
  end

  def new
    @quiz = Quiz.new
    respond_with(@quiz)
  end

  def edit
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.creator = current_user
    @quiz.save
    respond_with(@quiz)
  end

  def update
    @quiz.update(quiz_params)
    respond_with(@quiz)
  end

  def destroy
    @quiz.destroy
    respond_with(@quiz)
  end

  private
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    def quiz_params
      params.require(:quiz).permit(:name, :description, :creator_id, :published, :image)
    end
end
