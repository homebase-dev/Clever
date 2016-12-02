class NoveltiesController < ApplicationController
  before_action :set_novelty, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @novelties = Novelty.all.order({ created_at: :desc }).page(params[:page]).per(20)
    #@novelties = Novelty.all.order({ created_at: :desc })
    respond_with(@novelties)
  end

  def show
    respond_with(@novelty)
  end

  def new
    @novelty = Novelty.new
    respond_with(@novelty)
  end

  def edit
  end

  def create
    @novelty = Novelty.new(novelty_params)
    @novelty.save
    respond_with(@novelty)
  end

  def update
    @novelty.update(novelty_params)
    respond_with(@novelty)
  end

  def destroy
    @novelty.destroy
    respond_with(@novelty)
  end

  private
    def set_novelty
      @novelty = Novelty.find(params[:id])
    end

    def novelty_params
      params.require(:novelty).permit(:title, :text, :published, :priority, :image)
    end
end
