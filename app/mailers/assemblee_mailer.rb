class AssembleeMailer < ApplicationMailer
  
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: @assemblee.user.email, subject: "Émargement de votre participation à '#{@assemblee.nom_long}'").tap do |message|
      message.mailgun_options = {
        "tag" => [@assemblee.user.nom, @assemblee.user.prénom, "lien signature session gestionnaire"]
      }
    end
  end

  def lien_assemblee_participant(assemblee, user)
    @assemblee = assemblee
    @user = user
    mail(to: @user.email, subject: "Émargement de votre participation à '#{@assemblee.nom_long}'").tap do |message|
      message.mailgun_options = {
        "tag" => [@user.nom, @user.prénom, "lien signature session participant"]
      }
    end
  end

  def nouvelle_assemblee(assemblee_id)
    @assemblee = Assemblee.find(assemblee_id)
    mail(to: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com", subject: "Nouvelle session : '#{@assemblee.nom}'")
  end
  
end
