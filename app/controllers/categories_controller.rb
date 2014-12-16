class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @quiz = Quiz.find(params[:quiz_id])
    @quiz_categories = @quiz.categories
    respond_with(@quiz_categories)
  end

  def show
    Category.find(params[:id])
    respond_with(@category)
  end

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @category = Category.new
    respond_with(@quiz, @category)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @category = Category.new(category_params)
    @category.quiz = @quiz
    @category.creator_id = current_user.id
    @category.save
    respond_with(@quiz, @category)
  end

  def update
    @category.update(category_params)
    respond_with(@category)
  end

  def destroy
    @quiz = @category.quiz
    @category.destroy
    respond_with(@quiz, @category)
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :creator, :quiz, :description, :published)
    end
end
