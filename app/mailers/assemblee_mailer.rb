class AssembleeMailer < ApplicationMailer
  def lien_assemblee(assemblee)
    @assemblee = assemblee
    mail(to: @assemblee.user.nom, subject: "Lien de signature de l'assemblée")
  end
end
