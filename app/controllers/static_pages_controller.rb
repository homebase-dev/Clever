class StaticPagesController < ApplicationController
  layout "application"
  
  def home
    logger.debug "HOME ACTION"
  end

  def faq
    @all_published_faqs = (Faq.all.published.order('created_at DESC'))
    @top_faq = @all_published_faqs.first
    @older_faqs = @all_published_faqs.drop(1)
  end

  def about
  end

  def contact
  end

  def news
    @all_novelties_faqs = (Novelty.all.published.order('created_at DESC'))
    @top_novelty = @all_novelties_faqs.first
    @older_novelties = @all_novelties_faqs.drop(1)
  end

  def quiz
  end
  
  def profile
  end
  
  def admin
    
    
  end
end
