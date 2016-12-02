class BlogEntriesController < ApplicationController
  before_action :set_blog_entry, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user && current_user.admin?
      @blog_entries = BlogEntry.all.order('id DESC').page(params[:page]).per(20)
      #@blog_entries = BlogEntry.all
    elsif current_user
      @blog_entries = BlogEntry.where(user: current_user).order('id DESC').page(params[:page]).per(20)
    else
      @blog_entries = BlogEntry.none.page(params[:page]).per(20)
    end
    respond_with(@blog_entries)
  end

  def show
    referer_hash = Rails.application.routes.recognize_path(request.referer)
    if referer_hash[:controller] == 'blog_entries' && referer_hash[:action] == 'edit' || referer_hash[:controller] == 'blog_entries' && referer_hash[:action] == 'new'
      @back_to_my_blog = true
    end
    
    puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    puts referer_hash
    
    respond_with(@blog_entry)
  end

  def new
    @blog_entry = BlogEntry.new
    respond_with(@blog_entry)
  end

  def edit
  end

  def create
    @blog_entry = BlogEntry.new(blog_entry_params)
    @blog_entry.user = current_user
    flash[:notice] = 'BlogEntry was successfully created.' if @blog_entry.save
    respond_with(@blog_entry)
  end

  def update
    if current_user != @blog_entry.user && !current_user.admin?
      flash[:error] = 'BlogEntry konnte nicht geupdated werden: fehlende Berechtigung.'
      return respond_with(@blog_entry)
    end
    #@blog_entry.user = current_user
    flash[:notice] = 'BlogEntry was successfully updated.' if @blog_entry.update(blog_entry_params)
    respond_with(@blog_entry)
  end

  def destroy
    @blog_entry.destroy
    referer_hash = Rails.application.routes.recognize_path(request.referer)
    if referer_hash[:controller] == 'static_pages' && referer_hash[:action] == 'profile_blog'
      redirect_to static_pages_profile_blog_path
    else
      respond_with(@blog_entry)
    end
  end

  private
    def set_blog_entry
      @blog_entry = BlogEntry.find(params[:id])
    end

    def blog_entry_params
      params.require(:blog_entry).permit(:title, :text, :published, :user_id)
    end
end
