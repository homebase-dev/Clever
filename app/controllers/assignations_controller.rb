class AssignationsController < ApplicationController
  before_action :set_assignation, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @assignations = Assignation.all
    respond_with(@assignations)
  end

  def show
    respond_with(@assignation)
  end

  def new
    @assignation = Assignation.new
    respond_with(@assignation)
  end

  def edit
  end

  def create
    @assignation = Assignation.new(assignation_params)
    @assignation.save
    respond_with(@assignation)
  end

  def update
    @assignation.update(assignation_params)
    respond_with(@assignation)
  end

  def destroy
    @assignation.destroy
    respond_with(@assignation)
  end

  private
    def set_assignation
      @assignation = Assignation.find(params[:id])
    end

    def assignation_params
      params.require(:assignation).permit(:test_id, :question_id)
    end
end
