class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user

    mail(to: @user.email, 
        bcc: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com",
        subject: "[Émargements] Bienvenue !'")

  end
end
