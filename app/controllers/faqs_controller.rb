class FaqsController < ApplicationController
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @faqs = Faq.all
    respond_with(@faqs)
  end

  def show
    respond_with(@faq)
  end

  def new
    @faq = Faq.new
    respond_with(@faq)
  end

  def edit
  end

  def create
    @faq = Faq.new(faq_params)
    @faq.save
    respond_with(@faq)
  end

  def update
    @faq.update(faq_params)
    respond_with(@faq)
  end

  def destroy
    @faq.destroy
    respond_with(@faq)
  end

  private
    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(:title, :text, :published, :priority)
    end
end
