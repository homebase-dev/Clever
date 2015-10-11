class UserMailer < ActionMailer::Base
  default from: (I18n.t 'invoice.email.sender') #"from@example.com"
  
  
 
  def invoice_email(user, invoice_pdf_filename)
    @user = user
    #@url  = 'http://example.com/login'
    attachments['rechnung.pdf'] = File.read(invoice_pdf_filename)
    
    to = get_email_to(@user)
    
    mail(to: to, subject: (I18n.t 'invoice.email.subject'))
  end
  
  
  def get_email_to(user)
    to = user.email
    
    if Rails.env.development?
      to = 'tian.hofer@gmail.com'
    end
    
    to  
  end
  
  
end
