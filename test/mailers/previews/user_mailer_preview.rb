# Preview all emails at http://localhost:3000/rails/mailers/assemblee_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome
    UserMailer.welcome(User.last)
  end
end
