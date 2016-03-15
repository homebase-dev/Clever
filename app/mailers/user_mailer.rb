class UserMailer < ActionMailer::Base
  default from: (I18n.t 'invoice.email.sender')

 
  def invoice_email(user, invoice_pdf_filename)
    @user = user
    subject = (I18n.t 'invoice.email.subject')
    attachments['rechnung.pdf'] = File.read(invoice_pdf_filename)

    to = get_email_to(@user)
    to_admin = get_email_admin
    to_debug = get_email_debug
    
    if Rails.env.development?
      to = (I18n.t 'invoice.email.debug_receiver')
      to_admin = to
      to_debug = to
    end    
    
    logger.info "Preparing invoice email ..."
    logger.info "to #{to}"
    logger.info "bbc #{to_admin}"
    
    if send_invoice_to_customer? 
      # send invoice to customer email and a blind carbon copy to admin
      logger.info "send invoice to customer and bbc admin"
      mail(to: to, bcc: to_admin, subject: subject)
    else
      # send invoice just to admin
      logger.info "send invoice to admin only"
      mail(to: to_admin, subject: subject)      
    end
    
    mail(to: to_debug, subject: "Debug: #{subject}")
    
  end
  
  
  def get_email_to(user)
    user.email
  end
  
  def get_email_admin
    (I18n.t 'invoice.email.sender') #default recipient: admin
  end
  
  def get_email_debug
    (I18n.t 'invoice.email.debug_receiver') #default recipient: admin
  end
  
  def send_invoice_to_customer?
    send_invoice_to_customer = Settings[:send_invoice_to_customer] == true
    send_invoice_to_customer
  end
  
end
