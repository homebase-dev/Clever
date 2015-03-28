class UserMailer < ActionMailer::Base
  default from: 'tian.hofer@gmail.com'#"from@example.com"
  
  
 
  def bill_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: 'tian.hofer@gmail.com', subject: 'Here is your bill!') #@user.email
  end
  
  
end
