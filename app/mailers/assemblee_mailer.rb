class AssembleeMailer < ApplicationMailer
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: @assemblee.user.email, subject: "Émargement de l'assemblée '#{@assemblee.nom}'").tap do |message|
      message.mailgun_options = {
        "tag" => [@assemblee.user.nom, @assemblee.user.prénom, "lien assemblée gestionnaire"]
      }
    end
  end

  def lien_assemblee_participant(assemblee, user)
    @assemblee = assemblee
    @user = user
    mail(to: @user.email, subject: "Émargement de l'assemblée '#{@assemblee.nom}'").tap do |message|
      message.mailgun_options = {
        "tag" => [@user.nom, @user.prénom, "lien assemblée participant"]
      }
    end
  end

  def nouvelle_assemblee(assemblee_id)
    @assemblee = Assemblee.find(assemblee_id)
    mail(to: "philippe.nougaillon@gmail.com, pierreemmanuel.dacquet@gmail.com", subject: "Nouvelle assemblée : '#{@assemblee.nom}'")
  end
end
